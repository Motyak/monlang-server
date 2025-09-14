
var tern (cond, if_true, if_false):{
    var res _
    cond && {res := if_true}
    cond || {res := if_false}
    res
}

var even? _
var odd? _

even? := (n):{
    tern(n == 0, $true, {
        odd?(n + -1)
    })
}

odd? := (n):{
    even?(n) == $false
}

var trace (fn, fn_name):{
    fn
    var traced_fn (args...):{
        print("calling " + fn_name + " with args: " + List(args...))
        fn(args...)
    }
    traced_fn
}

-- even? := trace(even?, 'even?)
odd? := trace(odd?, 'odd?)

print(even?(5))
-- print(even?(645))
