
'===tern===

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

'===Pair===

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

'===Optional===

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

'===LazyList===

var Pair? (left, right):{
    Optional($true, Pair(left, right))
}
var END {
    Optional($false, _)
}

var subscript (ll, nth):{
    var - (lhs, rhs):{
        lhs + rhs + -2 * rhs
    }
    var >= (lhs, rhs):{
        lhs > rhs || lhs == rhs
    }

    nth >= 1 || ERR("nth should be greater than zero")

    var subscript_rec _
    subscript_rec := (ll, nth):{
        tern(nth == 1, left(some(ll)), {
            subscript_rec(right(some(ll)), nth - 1)
        })
    }

    subscript_rec(ll, nth)
}

'===RangeIterator===

var LazyRange<= _
LazyRange<= := (from, to):{
    tern(from > to, END, {
        Pair?(from, LazyRange<=(from + 1, to))
    })
}

var RangeIterator<= (from, to):{
    var range LazyRange<=(from, to)

    var Number? (n):{
        Optional($true, n)
    }

    var next (peek?):{
        tern(none?(range), END, {
            var res left(some(range))
            peek? || {
                range := right(some(range))
            }
            Number?(res)
        })
    }

    next
}

var next (iterator):{
    iterator(0)
}
var peek (iterator):{
    iterator(1)
}

var until _
until := (cond, do):{
    cond() || {
        do()
        until(cond, do)
    }
}

var foreach (OUT iterable, fn):{
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

    var Iterator::foreach (iterator, fn):{
        var curr next(iterator)
        until(():{none?(curr)}, ():{
            fn(some(curr))
            curr := next(iterator)
        })
    }

    var is_lambda (x):{
        Str(x) == "<lambda>"
    }

    !tern(is_lambda(iterable), foreach(&iterable, fn), {
        Iterator::foreach(iterable, fn)
    })
}

var str "fds"
var list [1, 2, 3]
var it RangeIterator<=(1, 4)

foreach(&str, (OUT c):{c := 'x})
print(str)
var newstr foreach(str, (OUT c):{c := 'y})
print(str)
print(newstr)

foreach(&list, (OUT n):{n := 0})
print(list)
var newlist foreach(list, (OUT n):{n := 7})
print(list)
print(newlist)

foreach(it, (x):{print(x)})
