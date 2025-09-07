

var tern (cond, if_true, if_false):{
    var res _
    cond && {res := if_true}
    cond || {res := if_false}
    res
}

var Pair (OUT left, OUT right):{
    var dispatcher (op):{
        tern(op == 'left, ():{left}, {
            tern(op == 'right, ():{right}, {
                die()
            })
        })
    }
    dispatcher
}

-- {
    var pair ():{
        var a 13
        var b 37
        Pair(&a, &b)
    }

    pair()('left)()
}

-- {
    var pair {
        var a 13
        var b 37
        Pair(&a, &b)
    }

    print(pair('left)())
}

{
    var a 13
    var b 37
    var pair Pair(&a, &b)
    a := 33
    print(pair('left)())
}
