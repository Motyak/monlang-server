var subscript (arr, nth):{arr[#nth]}

var program ```
    \
```

"===Optional=========================="

var Optional (some?, val):{
    var none? ():{
        not(some?)
    }
    
    var some ():{
        some? || {
            print("ERR calling some() on empty Optional")
            exit(1)
        }
        val
    }
    
    '----------------
    
    var dispatcher (msg_id):{
        tern(msg_id == 0, none?, {
            tern(msg_id == 1, some, {
                print("ERR invalid msg_id in dispatcher: `" + msg_id + "`")
                exit(1)
            })
        })
    }
    
    dispatcher
}

var none? (opt):{
    opt(0)()
}

var some (opt):{
    opt(1)()
}

"===InputStream======================="

var Char? (c):{
    Optional($true, c)
}
var EOF {
    Optional($false, _)
}

var InputStream (str):{
    var nth 1

    var next (peek?):{
        tern(nth > len(str), EOF, {
            var res Char?(subscript(str, nth))
            peek? || {nth += 1}
            res
        })
    }

    next
}

var peek (is):{is(true)}
var next (is):{is(false)}

"===LV1================================="

var g_currIndent 0
var g_buffer ""

var BUFFER_MODE $false

var print (str):{
    var TAB_SIZE 2
    var str_with_indent g_currIndent * TAB_SIZE * " " + str
    tern(BUFFER_MODE, {g_buffer += str_with_indent}, {
        print(str_with_indent)
    })
}

"--------------"

var parseAtom (input):{
    var atom ""
    until(peek(input) in "({:\"\n", (_):{
        atom += next(input)
    })
    print("-> Atom: `" + atom + "`")
}

var peekQuotation? (input):{
    peek(input) == "\""
}

var parseQuotation (input):{
    var _delimiter next(input)
    var quoted ""
    until(peek(input) == "\"", (_):{
        quoted += next(input)
    })
    var __delimiter next(input)
    print("-> Quotation: `" + quoted + "`")
}

"--------------"

var peekParenthesesGroup? (input):{
    peek(input) == "("
}

var parseTerm _

var parseParenthesesGroup (input):{
    var _initiator next(input)
    print("-> ParenthesesGroup")
    g_currIndent += 1
    until(peek(input) == ")", (1st_it?):{
        1st_iter? || {var _continuator next(input)}
        var TERMINATOR_CHARS ",)"
        parseTerm(input, TERMINATOR_CHARS)
    })
    g_currIndent -= 1
    var _terminator next(input)
}

var peekCurlyBracketsGroup? (input):{
    peek(input) == "{"
}

var parseSentence _

var parseCurlyBracketsGroup (input):{
    var _initiator next(input)
    print("-> CurlyBracketsGroup")
    g_currIndent += 1
    until(peek(input) == "}", (_):{
        parseSentence(input)
    })
    g_currIndent -= 1
    var _terminator next(input)
}

var parseWord _

var parsePostfixPG (input):{
    
}

var peekAssociation? (input):{
    peek(input) == ":"
}

var parseAssociation (input):{

}

"--------------"

parseWord := (input):{
    BUFFER_MODE := $true

    tern(peekCurlyBracketsGroup?(input), parseCurlyBracketsGroup(input), {
        tern(peekParenthesesGroup?(input), parseParenthesesGroup(input), {
            tern(peekQuotation?(input), parseQuotation(input), {
                parseAtom(input)
            })
        })
    })
    
    tern(peekParenthesesGroup?(input), parsePostfixPG(input), {
        term(peekAssociation?(input), parseAssociation(input)), {
            ; flush buffer
        }
    })
}

parseTerm := (input, terminatorChars):{
    print("-> Term")
    g_currIndent += 1
    until(peek(input) in terminatorChars, (1st_it?):{
        1st_it? || {var _continuator next(input)}
        parseWord(input)
    })
    g_currIndent -= 1
}

parseSentence := (input):{
    print("-> Sentence")
    g_currIndent += 1
    until(peek(input) == "\n", (1st_it?):{
        1st_it? || {var _continuator next(input)}
        parseWord(input)
    })
    g_currIndent -= 1
    var _terminator next(input)
}

var parseProgram (input):{
    print("-> Program")
    g_currIndent += 1
    until(peek(input) == EOF, (_):{
        parseSentence(input)
    })
    g_currIndent -= 1
}

"===main======================================"

parseProgram(program)
