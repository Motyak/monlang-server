
var tern (cond, if_true, if_false):{
    var res _
    cond && {res := if_true}
    cond || {res := if_false}
    res
}

var !tern (cond, if_false, if_true):{
    tern(cond, if_true, if_false)
}

var count 0

var fib {
    var fib _

    fib := (n):{
        count += 1
        !tern(n, 0, !tern(n + -1, 1, {
            fib(n + -2) + fib(n + -1)
        }))
    }

    fib
}

var res fib(24)

print(res)
print(count)
