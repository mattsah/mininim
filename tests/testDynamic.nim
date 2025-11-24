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
