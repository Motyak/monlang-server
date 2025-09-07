
var tern (cond, if_true, if_false):{
    var res _
    cond && {res := if_true}
    cond || {res := if_false}
    res
}

var until (cond, do):{
    var loop _
    loop := ():{
        cond() || {
            do()
            _ := loop()
        }
        ;
    }
    loop()
}

var foreach (OUT container, fn):{
    var nth 1
    until(():{nth > len(container)}, ():{
        fn(&container[#nth])
        nth += 1
    })
    container
}

'========================================

var Variant (type, val):{
    ['type:type, 'val:val]
}

var visit (variant, visitor):{
    let type variant.type
    let op visitor[type]
    let val variant.val
    op(val)
}

'====================================

var Atom! (fields):{
    fields['value]? || die("not an Atom")
    fields
}

var Group! (fields):{
    fields['words]? || die("not a Group")
    fields
}

var Word (type, fields):{
    tern(type == 'Atom, Atom!(fields), {
        tern(type == 'Group, Group!(fields), {
            die ("Unknown Word type: `" + type + "`")
        })
    })
    Variant(type, fields)
}

var AtomWord (value):{
    Word('Atom, ['value:value])
}

var GroupWord (words):{
    Word('Group, ['words:words])
}

'===main===

var word GroupWord([
    AtomWord('1)
    AtomWord('2)
    GroupWord([
        AtomWord('3)
        AtomWord('4)
    ])
])

var visitor _
visitor := [
    'Atom => (atom):{
        print("Atom: `" + atom.value + "`")
    }

    'Group => (group):{
        print("Group:")
        foreach(group.words, (word):{
            visit(word, visitor)
        })
    }
]

visit(word, visitor)
