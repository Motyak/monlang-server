{
    var str "fds"
    var newstr str
    str[#1] := "d"
    print(str, newstr)
}

{
    var arr ["a", "b", "c"]
    var first arr[#1]
    first[#1] := "x"
    print(first, arr)
}
