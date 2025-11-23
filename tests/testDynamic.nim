import
    unittest,
    mininim/dynamic

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

    test "equality and inequality":
        check(~1 == ~1)
        check(~1 == ~1.5)
        check(~1 != ~2.0)
