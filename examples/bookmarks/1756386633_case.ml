
var CaseAnalysis ():{
    var end $false
    var fn (cond, do):{
        end == $nil && {
            die("additional case succeeding a fallthrough case")
        }
        end ||= cond && {
            _ := do
            $true
        }
        "NOTE: don't eval cond if end"
        end == $false && cond == $nil && {
            _ := do
            end := $nil
        }
        ;
    }
    fn
}

var case CaseAnalysis()

-- just for tracing what gets evaluated
var == (a, b):{
    print("testing " + a + " == " + b)
    a == b
}

case(1 == 2, {
    print("A")
})

case(2 == 2, {
    print("B")
})

case(3 == 3, {
    print("C")
})

case(_, {
    print("D")
})

-- case(_, {
    -- print("can't happen")
})
