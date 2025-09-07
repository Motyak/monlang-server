
var Person (name, age):{
    var res [:]
    res['name] := name
    res['age] := age
    res
}

var introduce (person):{
    var res ""
    res += "Vous êtes " + person.name
    res += " et vous avez " + person.age + " ans."
    res
}

var mutate (OUT person):{
    person.name := "Gilbert"
    person
}

var person Person('Tommy, 28)
-- var person ['age:28]
mutate(&person)

-- var res introduce(['name:'Tommy, 'age:28])
var res introduce(person)
print(res)
