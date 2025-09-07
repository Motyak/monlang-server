
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

var delay (x):{
    var delayed ():{x}
    delayed
}

var id (x):{
    print("evaluated: " + x)
    x
}

var somevar $false

{
    var if_true delay(id("A"))
    var if_false delay(id("B"))
    var res tern(somevar, if_true(), if_false())
    print(res)
}

{
    var if_true id("A")
    var if_false id("B")
    var res tern(somevar, if_true, if_false)
    print(res)
}
