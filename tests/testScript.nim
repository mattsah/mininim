import
    unittest,
    mininim/script

suite "script":
    test "can parse positive numbers":
        check(Script.eval("5") == 5)
        check(Script.eval("3.14") == 3.14)
        check(Script.eval("42") == 42)

    test "can parse negative numbers":
        check(Script.eval("-5") == -5)
        check(Script.eval("-3.14") == -3.14)
        check(Script.eval("-42") == -42)

    test "can use unary minus operator":
        check(Script.eval("-x", (x: 5)) == -5)
        check(Script.eval("-y", (y: 3.14)) == -3.14)
        check(Script.eval("-(5 + 3)") == -8)

    test "can handle expressions with negative numbers":
        check(Script.eval("5 + -3") == 2)
        check(Script.eval("-5 + 3") == -2)
        check(Script.eval("-5 + -3") == -8)
        check(Script.eval("5 - -3") == 8)
        check(Script.eval("-5 - 3") == -8)
        check(Script.eval("-5 - -3") == -2)

    test "can use not operator":
        check(Script.eval("not true") == false)
        check(Script.eval("not false") == true)
        check(Script.eval("!true") == false)
        check(Script.eval("!false") == true)
        check(Script.eval("not (5 > 3)") == false)
        check(Script.eval("not (5 < 3)") == true)

    test "can use complex unary expressions":
        # Test unary minus with complex expressions
        check(Script.eval("-(5 + 3)") == -8)
        check(Script.eval("-(10 - 2)") == -8)
        check(Script.eval("-(x + y)", (x: 5, y: 3)) == -8)

        # Test not operator with complex expressions
        check(Script.eval("not (x > y)", (x: 5, y: 3)) == false)
        check(Script.eval("not (x < y)", (x: 5, y: 3)) == true)

        # Test field access with unary operators
        check(Script.eval("!obj.flag", (obj: (flag: true))) == false)
        check(Script.eval("!obj.flag", (obj: (flag: false))) == true)
        check(Script.eval("-obj.value", (obj: (value: 5))) == -5)

        # Test operator precedence - unary operators should bind tighter than binary operators
        check(Script.eval("-5 + 3") == -2)  # Should be (-5) + 3, not -(5 + 3)
        check(Script.eval("-5 - 3") == -8)  # Should be (-5) - 3, not -(5 - 3)
        check(Script.eval("!true == false") == true)  # Should be (!true) == false, not !(true == false)

        # Test complex nested expressions with unary operators
        check(Script.eval("!(foo: true).foo") == false)  # !(true) = false
        check(Script.eval("-(foo: (value: 5)).foo.value") == -5)  # -(5) = -5
        check(Script.eval("!array[0]", (array: [true, false])) == false)  # !(true) = false
        check(Script.eval("-array[1]", (array: [1, 5, 3])) == -5)  # -(5) = -5
        check(Script.eval("-array[-2]", (array: [1, 5, 3])) == -5)  # -(5) = -5