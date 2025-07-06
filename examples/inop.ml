
var until {
    var until _
    var 1st_it $true
    until := (cond, do):{
        cond() || {
            do(1st_it)
            1st_it := $false
            until(cond, do)
        }
    }
    (until)
}

var in (elem, arr):{
    var i 1
    var found $false
    until(():{found || i > len(arr)}, (_):{
        found ||= arr[#i] == elem
        i += 1
    })
    found
}

print("g" in "sdf")
