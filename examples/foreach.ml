
var tern (cond, if_true, if_false):{
    var res _
    cond && {res := if_true}
    cond || {res := if_false}
    res
}

var < (lhs, rhs):{
    tern(lhs > rhs, $false, {
        tern(lhs == rhs, $false, {
            $true
        })
    })
}

var shift-left (subscriptable):{
    tern(len(subscriptable) < 2, subscriptable[#1..<1], {
        subscriptable[#2..-1]
    })
}

var foreach _
foreach := (subscriptable, do):{
    tern(len(subscriptable) == 0, {}, {
        do(subscriptable[#1])
        foreach(shift-left(subscriptable), do)
    })
}

var list "0123456789" + "ABCDEF"
```
    var list [0 .. 9, 'A .. 'F] |> join("")
```

foreach(list, (d1):{
    foreach(list, (d2):{
        print("0x" + d1 + d2)
    })
})

```
    foreach list {
        let d1 $1
        foreach list {
            let d2 $1
            "0x<$d1><$d2>" |> print()
        }
    }
```
