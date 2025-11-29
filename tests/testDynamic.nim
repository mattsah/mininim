import
    unittest,
    mininim/dynamic

type
    Foo = object
        bar: string

suite "dynamic":
    test "can do literal assignments (:=)":
        a := 1
        b := 2.0
        c := "three"
        d := @[]
        e := []
        f := ()
        g := true
        h := false
        i := nil

    test "can do literal assignments (let=~)":
        let a = ~1
        let b = ~2.0
        let c = ~"three"
        let d = ~@[]
        let e = ~[]
        let f = ~()
        let g = ~true
        let h = ~false
        let i = ~nil

    test "can do implicit assignments (var=)":
        var a: dyn = 1
        var b: dyn = 2.0
        var c: dyn = "three"
#       var d: dyn = @[] # No way to resolve this at present
#       var e: dyn = [] # No way to resolve this at present
        var f: dyn = ()
        var g: dyn = true
        var h: dyn = false
        var i: dyn = nil # kinda works, ref is actually nil, need to handle explicitly

    test "can do logical comparisons":
        check(~0 != ~nil)
        check(~false != ~nil)

        check(~1 == ~1)
        check(~1 != ~2)
        check(~1 == ~1.0)
        check(~1 != ~2.0)
        check(~1.0 == ~1)
        check(~1 != ~1.5)
        check(~1.5 != ~1)
        check(~2.0 != ~1)

        check(~1 == ~"1")
        check(~1 != ~"2")
        check(~"1" == ~1)
        check(~"2" != ~1)
        check(~1 == ~"1.0")
        check(~1 != ~"1.5")
        check(~"1.0" == ~1)
        check(~"1.5" != ~1)

        check(~1 >= ~1)
        check(~2 > ~1)
        check(not(~1 > ~2))
        check(not(~1 >= ~2))

        check(~1 >= ~true)
        check(not(~1 > true))
        check(not(~1 < true))
        check(~1 > ~false)
        check(not(~0 < ~false))
        check(not(~0 > false))
        check(~0 < ~true)

        check(~"abundance" < ~"bobcat")
        check(not(~"abundance" > ~"bobcat"))

        check(~"abundance" <= ~"bobcat")
        check(not(~"abundance" >= ~"bobcat"))

        check(~"abundance" != ~"bobcat")
        check(not(~"abundance" == ~"bobcat"))

        check(~[1, 2, 3] == ~[1, 2, 3])
        check(~(name: "Suzy", age: 13) == ~(name: "Suzy", age: 13))

    test "can do weird math":
        check(~1 + ~nil == ~1)
        check(~nil + ~1 == ~nil)

        check(~1.0 + ~nil == ~1)
        check(~nil + ~1.0 == ~nil)

        check(~1.5 + ~nil != ~1)

        check(~1 + "test" == ~"1test")
        check("test" + ~1 == ~"test1")

    test "can do weird function [len()]":
        check(~1.len == ~1)
        check(~125.len == ~3)
        check(~(-125).len == ~(-3))
        check(~3.14159.len == ~1.5)
        check(~(-3.14159).len == ~(-1.5))
        check(not(~(-3.14159).len == ~(-1.6)))

    test "can do weird function [has()]":
        check((~[1, 2, "test"]).has("test") == true)
        check((~[1, 2, "test"]).has(3) == false)
        check((~(name: "Bob")).has("name") == true)
        check((~(name: nil)).has("name") == false)
        check((~(name: 0)).has("name") == true)
        check((~"foobar").has("oba") == true)
        check((~"foobar").has("e") == false)

    test "can do array operations and mutations":
        var arr = ~[1, 2, 3]
        check(arr[~0] == ~1)
        check(arr[~1] == ~2)
        check(arr[~2] == ~3)

        arr[~1] = ~99
        check(arr[~1] == ~99)

        check(arr.len == ~3)

        let first = << arr
        check(first == ~1)
        check(arr.len == ~2)
        check(arr[~0] == ~99)

        let last = >> arr
        check(last == ~3)
        check(arr.len == ~1)

        arr << ~42
        check(arr.len == ~2)
        check(arr[~1] == ~42)

    test "can do object operations and mutations":
        var obj = ~(name: "Alice", age: 30)
        check(obj.name == ~"Alice")
        check(obj.age == ~30)

        obj.name = ~"Bob"
        check(obj.name == ~"Bob")

        obj["city"] = ~"New York"
        check(obj.city == ~"New York")

        check(obj.has("name") == true)
        check(obj.has("country") == false)

        obj["age"] = ~nil
        check(obj.has("age") == false)

    test "can do complex array concatenation":
        let arr1 = ~[1, 2, 3]
        let arr2 = ~[4, 5, 6]
        let combined = arr1 + arr2
        check(combined.len == 6)
        check(combined[0] == 1)
        check(combined[3] == 4)
        check(combined[5] == 6)

    test "can do array indexing with negative indices":
        let arr = ~[10, 20, 30, 40]
        check(arr[-1] == 40)
        check(arr[-2] == 30)
        check(arr[-3] == 20)
        check(arr[-4] == 10)

    test "can do string indexing":
        let str = ~"hello"
        check(str[0] == "h")
        check(str[1] == "e")
        check(str[4] == "o")
        check(str[-1] == "o")
        check(str[-2] == "l")

    test "can handle empty arrays and objects":
        let emptyArr = ~[]
        check(emptyArr.len == 0)
        check(toBool(emptyArr) == false)

        let emptyObj = ~()
        check(emptyObj.len == 0)
        check(toBool(emptyObj) == false)

        check(emptyArr + 5 == [5])
        check(emptyObj.has("any") == false)
