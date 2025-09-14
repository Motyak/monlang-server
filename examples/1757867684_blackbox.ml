

var fn (x):{
    x()
    x()
}

var somefn _
somefn := ():{
    var old_somefn somefn
    print("hello")
    somefn := ():{
        print("goodbye")
        somefn := old_somefn
    }
}

-- somefn()
-- somefn()
-- somefn()
-- somefn()

fn(somefn)
-- fn(&somefn)
