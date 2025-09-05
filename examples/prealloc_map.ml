
-- var map {
    var map [:]

    var i 1
    var loop _
    loop := ():{
        i > 100 || {
            map[i] := _
            i += 1
            loop()
        }
    }
    loop()

    map
}

var map {
    var map 100 * [[_, _]]

    var i 1
    var loop _
    loop := ():{
        i > 100 || {
            map[#i][#1] := i
            i += 1
            loop()
        }
    }
    loop()

    [:] | map
}

print(map)

