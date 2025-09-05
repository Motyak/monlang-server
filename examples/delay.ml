
var delay (x):{
    var delayed ():{x}
    delayed
}

var id (x):{
    print("evaluated: " + x)
    x
}

-- var x ():{id(123)}
var x delay(id(123))

print(x())
print(x())


