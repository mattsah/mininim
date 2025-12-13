import
    mininim,
    unittest

suite "missing":
    test "simple slice functions":
        for val in 0..10:
            check(val is int)

        let
            foo = 0..10

        for idx, val in foo:
            check(idx is int)
            check(val is int)

#        for idx, val in 0..10: # does not work - wrong number of arguments
#            check(idx is int)
#            check(val is int)

        for idx, val in foo.map(
            proc(idx: int, val: int): (string, string) =
                result = ($idx, $val)
        ):
            check(idx is string)
            check(val is string)
