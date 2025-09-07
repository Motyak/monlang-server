
var foreach (container, do):{
    var nth 1
    var loop _
    loop := ():{
        nth > len(container) || {
            do(container[#nth])
            nth += 1
            loop()
        }
    }
    loop()
}

var < (a, b):{
    var res $true
    a == b && {res := $false}
    a > b && {res := $false}
    res
}

var tern (cond, if_true, if_false):{
    var res _
    cond && {res := if_true}
    cond || {res := if_false}
    res
}

var id {
    var FNV-1a (input):{
        input := Str(input)
        let str input
        var hash 2166136261
        foreach(str, (byte):{
            hash ^= byte
            hash *= 16777619
            hash < 0 && {
                hash := hash % 2^32 + 2^32
            }
        })
        hash
    }

    var count -2^33
    -- var count -9223372036854775807
    var next_id ():{
        count += -1
        count > 0 && die("exceeded max nb of ids")
        count
    }

    var id (input):{
        tern(input == $nil, next_id(), {
            FNV-1a(input)
        })
    }

    id
}



print(id('fffds))
print(id('fffd))
print(id(_))
print(id(_))
