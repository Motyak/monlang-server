
var fn ():{
    _
}

{
    var filter (fn):{
        fn
        ():{fn()}
    }
    fn := filter(fn)
    fn()
}

-- {
    var filter (fn):{
        ():{fn()}
    }
    fn := filter(fn)
    fn()
}
