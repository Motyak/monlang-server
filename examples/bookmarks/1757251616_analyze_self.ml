
var tern (cond, if_true, if_false):{
    var res _
    cond && {res := if_true}
    cond || {res := if_false}
    res
}

var !tern (cond, if_false, if_true):{
    tern(cond, if_true, if_false)
}

var split (delim, str):{
    delim := Char(delim)

    var res []
    var curr ""
    var nth 1

    var loop _
    loop := ():{
        nth > len(str) || {
            !tern(str[#nth] == delim, {curr += str[#nth]}, {
                res += [curr]
                curr := ""
            })
            nth += 1
            loop()
        }
    }
    loop()
    res += [curr]

    res
}

var strip_indent (str):{
    var res ""
    var nth 1
    var is_leading_space $true

    var loop _
    loop := ():{
        nth > len(str) || {
            tern(str[#nth] == " ", {is_leading_space || {res += str[#nth]}}, {
                res += str[#nth]
                is_leading_space := $false
            })
            nth += 1
            loop()
        }
    }
    loop()

    res
}



-- var file ```
    a b c
    d e
```
var file slurpfile($srcname)
var lines split("\n", file)
var word_count 0

{
    var nth 1

    var loop _
    loop := ():{
        nth > len(lines) || {
            var line lines[#nth]
            line := strip_indent(line)
            len(line) == 0 || {
                var words split(" ", line)
                print(len(words), "=>", words)
                word_count += len(words)
            }
            nth += 1
            loop()
        }
    }

    loop()
}

-- print(strip_indent(lines[#3]))
print("SUM:", word_count)
