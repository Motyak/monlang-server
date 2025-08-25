
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

var Optional (some?, val):{
    var none? ():{
        not(some?)
    }

    var some ():{
        some? || {
            die("calling some() on empty Optional")
        }
        val
    }

    var dispatcher (op):{
        tern(op == 'none?, none?, {
            tern(op == 'some, some, {
                die("unknown Optional operation: `" + op + "`")
            })
        })
    }
    dispatcher
}

var none? (opt):{
    opt('none?)()
}

var some (opt):{
    opt('some)()
}

var Pair (left, right):{
    var selector (op):{
        tern(op == 'left, left, {
            tern(op == 'right, right, {
                die("unknown Pair operation: `" + op + "`")
            })
        })
    }
    selector
}

var left (pair):{
    pair('left)
}

var right (pair):{
    pair('right)
}

var Pair? (left, right):{
    Optional($true, Pair(left, right))
}

var END {
    Optional($false, _)
}

var LazyList {
    var LazyList-1+ _

    var LazyList (xs...):{
        tern($#varargs == 0, END, {
            LazyList-1+(xs...)
        })
    }

    LazyList-1+ := (x, xs...):{
        Pair?(x, LazyList(xs...))
    }

    LazyList
}

var subscript (subscriptable, nth):{
    nth == 0 && die("nth should differ from zero (less or greater)")

    var Stream::subscript (stream, nth):{
        nth > 0 || die("nth should be greater than zero")
        var subscript_rec _
        subscript_rec := (stream, nth):{
            tern(nth == 1, left(some(stream)), {
                subscript_rec(right(some(stream)), nth + -1)
            })
        }
        subscript_rec(stream, nth)
    }

    var lambda? (x):{
        var < (lhs, rhs):{
            not(lhs > rhs || lhs == rhs)
        }
        Str(x) == "<lambda>" && len(x) < 8
    }

    !tern(lambda?(subscriptable), subscriptable[#nth], {
        Stream::subscript(subscriptable, nth)
    })
}

var Stream::filter {
    var delay (x):{
        var delayed ():{x}
        delayed
    }

    var Stream::filter _
    Stream::filter := (pred, stream):{
        tern(none?(stream), END, {
            var curr left(some(stream))
            var next delay(Stream::filter(pred, right(some(stream))))
            !tern(pred(curr), next(), {
                Pair?(curr, next())
            })
        })
    }
    Stream::filter
}

var delay (x):{
    var delayed ():{x}
    delayed
}

var integers_starting_from_n _
integers_starting_from_n := (n):{
    Pair?(n, integers_starting_from_n(n + 1))
}

var divisible? (a, b):{
    a % b == 0
}

var sieve _
sieve := (stream):{
    var curr left(some(stream))
    var fn (n):{
        not(divisible?(n, curr))
    }
    var next delay(Stream::filter(fn, right(some(stream))))
    Pair?(curr, sieve(next()))
}

var primes sieve(integers_starting_from_n(2))
var res subscript(primes, 50)
-- var res subscript(primes, 148)
print(res)
