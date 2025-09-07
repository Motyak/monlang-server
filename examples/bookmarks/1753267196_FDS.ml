
var tern (cond, if_true, if_false):{
    var res _
    cond && {res := if_true}
    cond || {res := if_false}
    res
}

var - (n):{
    n + -2 * n
}

var foreach (OUT list, fn):{
    var foreach_rec {
        var i 1
        var foreach_rec _
        foreach_rec := (OUT list, fn):{
            fn(&list[#i])
            tern(i == len(list), list, {
                i += 1
                foreach_rec(&list, fn)
            })
        }
        foreach_rec
    }

    tern(len(list) == 0, list, {
        -- we create a local var in case..
        -- ..user has passed by delay rather..
        -- ..than ref (otherwise "lvaluing $nil" error)
        var newlist list
        foreach_rec(&newlist, fn)
        list := newlist
        newlist
    })
}

var upper (OUT c):{
    c := Str(Char(c) + -(Int(Char('a)) + -(Int(Char('A)))))
}

{
    var list ['f, 'd, 's]
    foreach(&list, upper)
    print(list)
}

{
    var list ['f, 'd, 's]
    -- returns the new list as well
    var newlist foreach(&list, upper)
    print('list, list)
    print('newlist, newlist)
}

{
    var list foreach(['f, 'd, 's], upper)
    print(list)
}
