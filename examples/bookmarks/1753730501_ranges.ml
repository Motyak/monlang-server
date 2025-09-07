var tern (cond, if_true, if_false):{
    var res _
    cond && {res := if_true}
    cond || {res := if_false}
    res
}

var !tern (cond, if_false, if_true):{
    tern(cond, if_true, if_false)
}

var not (bool):{
    tern(bool, $false, $true)
}

var ascii (c):{
    Int(Char(c))
}

var delay (x):{
    var delayed ():{x}
    delayed
}

var |> (input, fn):{
    fn(input)
}

var curry (fn):{
    var - (lhs, rhs):{
        lhs + rhs + -2 * rhs
    }

    var curried _
    curried := (args...):{
        tern($#varargs - len(fn) == 0, fn(args...), {
            (args2...):{curried(args..., args2...)}
        })
    }
    curried
}

var until _
until := (cond, do):{
    cond() || {
        do()
        until(cond, do)
    }
}

var Pair (left, right):{
    var dispatcher (msg_id):{
        tern(msg_id == 0, left, {
            tern(msg_id == 1, right, {
                print("ERR unknown Pair dispatcher msg_id: `" + msg_id + "`")
                exit(1)
            })
        })
    }
    dispatcher
}

var left (pair):{
    pair(0)
}

var right (pair):{
    pair(1)
}

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
                print("ERR unknown Optional dispatcher msg_id: `" + msg_id + "`")
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

var Pair? (left, right):{
    Optional($true, Pair(left, right))
}
var END {
    Optional($false, _)
}

var foreach (OUT subscriptable, fn):{
    var foreach (OUT container, fn):{
        tern(len(container) == 0, container, {
            -- we create a local var in case..
            -- ..user has passed by delay rather..
            -- ..than ref (otherwise "lvaluing $nil" error)
            var container' container

            var nth 1
            until(():{nth > len(container)}, ():{
                fn(&container'[#nth])
                nth += 1
            })

            container := container'
            container'
        })
    }

    var Stream::foreach _
    Stream::foreach := (stream, fn):{
        tern(none?(stream), END, {
            fn(left(some(stream)))
            Stream::foreach(right(some(stream)), fn)
        })
    }

    var is_lambda (x):{
        Str(x) == "<lambda>"
    }

    !tern(is_lambda(subscriptable), foreach(&subscriptable, fn), {
        Stream::foreach(&subscriptable, fn)
    })
}

var filter {
    var filter _
    filter := (pred, stream):{
        tern(none?(stream), END, {
            var curr left(some(stream))
            var next delay(filter(pred, right(some(stream))))
            !tern(pred(curr), next(), {
                Pair?(curr, next())
            })
        })
    }
    curry(filter)
}

var map {
    var map _
    map := (fn, stream):{
        tern(none?(stream), END, {
            var curr fn(left(some(stream)))
            var next delay(map(fn, right(some(stream))))
            Pair?(curr, next())
        })
    }
    curry(map)
}

-- increasing range from "from" up to "to" included
var LazyRange<= _
LazyRange<= := (from, to):{
    tern(from > to, END, {
        Pair?(from, LazyRange<=(from + 1, to))
    })
}

var stdout {
    curry((x):{print(x)})
}

'===main===

var ERR (msg):{
    print("ERR: " + msg)
    exit(1)
}

var <= (lhs, rhs):{
    not(lhs > rhs)
}

var - (lhs, rhs):{
    lhs + rhs + -2 * rhs
}

var sumOfDigits (n):{
    n := Str(n)
    var res 0
    foreach(n, (c):{
        ascii('0) <= c && c <= ascii('9) || ERR("not a number")
        res += ascii(c) - ascii('0)
    })
    res
}

var <> (lhs, rhs):{
    not(lhs == rhs)
}

var < (lhs, rhs):{
    not(lhs > rhs || lhs == rhs)
}

-- mod 10 not equal zero
var %10<>0 (n):{
    Str(n)[#-1] <> '0
}

var predicate (n):{
    %10<>0(n) && sumOfDigits(n) < 10
}

var fn (n):{
    n * 11 * 999
}

var seq LazyRange<=(1, 90)
-- foreach(seq, print)

seq := seq |> filter(predicate)
-- foreach(seq, print)

seq := seq |> map(fn)
-- foreach(seq, print)

var Iterator (subscriptable):{
    var Elem? (val):{
        Optional($true, val)
    }

    var Iterator (container):{
        var nth 1

        var next (peek?):{
            tern(nth > len(container), END, {
                var res container[#nth]
                peek? || {nth += 1}
                Elem?(res)
            })
        }

        next
    }

    var Iterator::fromStream (stream):{
        var next (peek?):{
            tern(none?(stream), END, {
                var res left(some(stream))
                peek? || {
                    stream := right(some(stream))
                }
                Elem?(res)
            })
        }

        next
    }

    var is_lambda (x):{
        Str(x) == "<lambda>"
    }

    !tern(is_lambda(subscriptable), Iterator(subscriptable), {
        Iterator::fromStream(subscriptable)
    })
}

var next (iterator):{
    iterator(0)
}
var peek (iterator):{
    iterator(1)
}

var in (elem, subscriptable):{
    var in (elem, container):{
        var i 1
        var found $false
        until(():{found || i > len(container)}, ():{
            found ||= container[#i] == elem
            i += 1
        })
        found
    }

    var Stream::in (elem, stream):{
        var it Iterator(stream)
        var found $false
        var curr next(it)
        until(():{found || none?(curr)}, ():{
            found ||= elem == some(curr)
            curr := next(it)
        })
        found
    }

    var is_lambda (x):{
        Str(x) == "<lambda>"
    }

    !tern(is_lambda(subscriptable), in(elem, subscriptable), {
        Stream::in(elem, subscriptable)
    })
}

var .. LazyRange<=

foreach(1 .. 10, (i):{
    print("wow amazing, curr val is: " + i)
})

7 in 1 .. 10 |> stdout
