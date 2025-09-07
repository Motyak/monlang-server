var subscript (arr, nth):{arr[#nth]}

```
    Current issue:
    - PG as left part of a PSBG or Assoc
    - PSBG or Assoc inside a CBG
    - ...
```

var program ```
    {
        a "b c"
        () (d + e) (f, g)
    }
    fds(sdf)
    a:b
    \
```

"===utils============================="

var tern (cond, if_true, if_false):{
    var res _
    cond && {res := if_true}
    cond || {res := if_false}
    res
}

var not (bool):{
    tern(bool, $false, $true)
}

var until {
    var until _
    until := (cond, do):{
        cond() || {
            do()
            until(cond, do)
        }
    }
    (until)
}

var while (cond, do):{
    until(():{not(cond())}, do)
}

var - {
    var sub-1+ _

    var sub (xs...):{
        tern($#varargs == 0, 0, {
            sub-1+(xs...)
        })
    }

    var neg (x):{
        x + -2 * x
    }

    sub-1+ := (x, xs...):{
        x + neg(sub(xs...))
    }

    sub
}

var in (elem, arr):{
    var i 1
    var found $false
    until(():{found || i > len(arr)}, ():{
        found ||= arr[#i] == elem
        i += 1
    })
    found
}

"===InputStream======================="

var EOF Char(-1)

var InputStream (str):{
    var nth 1

    var next (peek?):{
        tern(nth > len(str), EOF, {
            var res subscript(str, nth)
            peek? || {nth += 1}
            res
        })
    }

    next
}

var peek (is):{is($true)}
var next (is):{is($false)}

"===LV1================================="

var TAB_SIZE 2

var g_currIndent 0
var g_buffer ""
var BUFFER_MODE $false

var printout (str):{
    var indented_str g_currIndent * TAB_SIZE * " " + str
    tern(BUFFER_MODE, {g_buffer += tern(g_buffer == "", "", "\n") + indented_str}, {
        print(indented_str)
    })
}

"--------------"

var parseAtom (input):{
    var atom ""
    until(():{peek(input) in "(){}\",: \n"}, ():{
        atom += next(input)
    })

    "special case: `:=` atom"
    atom == "" && {
        atom += next(input)
        atom += next(input)
    }

    printout("-> Word: Atom: `" + atom + "`")
}

var peekQuotation? (input):{
    peek(input) == "\""
}

var parseQuotation (input):{
    var _delimiter next(input)
    var quoted ""
    until(():{peek(input) == "\""}, ():{
        quoted += next(input)
    })
    var __delimiter next(input)
    printout("-> Word: Quotation: `" + quoted + "`")
}

var peekParenthesesGroup? (input):{
    peek(input) == "("
}

var parseTerm _

var parseParenthesesGroup (input):{
    var _initiator next(input)
    printout("-> Word: ParenthesesGroup")
    g_currIndent += 1
    var 1st_iter? $true
    until(():{peek(input) == ")"}, ():{
        1st_iter? || {
            var _continuator next(input)
            var __continuator next(input)
        }
        var TERMINATOR_CHARS ",)"
        parseTerm(input, TERMINATOR_CHARS)
        1st_iter? := $false
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
    var __initiator next(input)
    printout("-> Word: CurlyBracketsGroup")
    g_currIndent += 1
    while(():{peek(input) == " "}, ():{
        var _indent next(input)
    })
    until(():{peek(input) == "}"}, ():{
        parseSentence(input)
        while(():{peek(input) == " "}, ():{
            var _indent next(input)
        })
    })
    g_currIndent -= 1
    var _terminator next(input)
}

var parseWord _

var parsePostfixPG (input):{
    var backupBuffer g_buffer
    g_buffer := ""
    printout("-> Word: PostfixParenthesesGroup")
    g_currIndent += 1
    g_buffer += "\n" + TAB_SIZE * " " + backupBuffer
    parseParenthesesGroup(input)
    g_currIndent -= 1
}

var peekAssociation? (input):{
    peek(input) == ":"
}

var parseAssociation (input):{
    var backupBuffer g_buffer
    g_buffer := ""
    printout("-> Word: Association")
    g_currIndent += 1
    g_buffer += "\n" + TAB_SIZE * " " + backupBuffer
    var _separator next(input)
    parseWord(input)
    g_currIndent -= 1
}

"--------------"

parseWord := (input):{
    var backup_BUFFER_MODE BUFFER_MODE
    BUFFER_MODE := $true

    tern(peekCurlyBracketsGroup?(input), parseCurlyBracketsGroup(input), {
        tern(peekParenthesesGroup?(input), parseParenthesesGroup(input), {
            tern(peekQuotation?(input), parseQuotation(input), {
                parseAtom(input)
            })
        })
    })

    tern(peekParenthesesGroup?(input), parsePostfixPG(input), {
        tern(peekAssociation?(input), parseAssociation(input), {
            _
        })
    })

    BUFFER_MODE := backup_BUFFER_MODE
    BUFFER_MODE || {
        g_buffer == "" || {
            print(g_buffer)
            g_buffer := ""
        }
    }
}

parseTerm := (input, terminatorChars):{
    printout("-> Term")
    g_currIndent += 1
    var 1st_iter? $true
    until(():{peek(input) in terminatorChars}, ():{
        1st_iter? || {var _continuator next(input)}
        parseWord(input)
        1st_iter? := $false
    })
    g_currIndent -= 1
}

parseSentence := (input):{
    printout("-> Sentence")
    g_currIndent += 1
    var 1st_iter? $true
    until(():{peek(input) == "\n"}, ():{
        1st_iter? || {var _continuator next(input)}
        parseWord(input)
        1st_iter? := $false
    })
    g_currIndent -= 1
    var _terminator next(input)
}

var parseProgram (input):{
    printout("-> Program")
    g_currIndent += 1
    until(():{peek(input) == EOF}, ():{
        parseSentence(input)
    })
    g_currIndent -= 1
}

"===main======================================"

var is InputStream(program)
parseProgram(is)
