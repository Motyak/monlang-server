
```
    in this alternative interpretation of comparison operators,
    `==` means equivalent (can be substituted for equal),
    and every value can be compared with any other (even $nil)
    therefore `<>` literally means less or greater than.

    furthermore, `a < b` is now always the same as `b > a`.
```

var tern (cond, if_true, if_false):{
    var res _
    cond && {res := if_true}
    cond || {res := if_false}
    res
}

var !tern (cond, if_false, if_true):{
    tern(cond, if_true, if_false)
}

var > (a, b):{
    !tern($type(a) == $type(b), $type(a) > $type(b), {
        tern(a == $nil, $false, {
            a > b
        })
    })
}

var < (a, b):{
    !tern($type(a) == $type(b), $type(b) > $type(a), {
        tern(a == $nil, $false, {
            b > a
        })
    })
}

var <> (a, b):{
    a < b || a > b
}

var == (a, b):{
    a <> b == $false
}

print(1.0 == 1)
print(1.0 < 1)
print(1.0 <> $nil)
print(1.0 > $nil)
