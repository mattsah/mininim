# Dynamic

The `mininim/dynamic` module provides dynamic types and the requisite logic to work with them, including extensible function/method calls.  While this module can be used stand-alone to provide dynamic typing features to Nim, it's most appropriately used by the `mininim/script` module to provide dynamic evaluated expressions.

## Common

```nim
import
    mininim,
    mininim/dynamic
```

## Declarations / Initialization

There are a few different ways which you can declare and/or initialize dynamic values.  The first and most obvious is by simply specifying the `dyn` type and assigning it, e.g.:

```nim
var
    number: dyn = 1
```

This, however, has some limitations since it's not possible to actually detect assignments to some "empty" values, e.g. `[]` or `@[]` or `nil`.  While there are mitigiations in place for `nil`, it is usually recommended when you are declaring values to use the dynamic assignment syntax:

```nim
number := 1
```

Using this syntax, it is completely possible to perform the following:

```
numbers := []
```

> **NOTE:** Using this syntax, you do not use the `let` or `var` keyword, as all dynamic values are "variable" given that certain mutation operators do exist.

If you absolutely feel the need to prevent mutations, you can use the "literal" syntax by preceding the value with `~`, which is otherwise mostly used as a shorthand in, well, "literal" contexts:

```nim
let
    numbers = ~[]
```

## Supported Types

At present, dynamic types effectively supports basic scalar types as well as strings, arrays/sequences, and "anonymous objects" of sorts as represented by tuples.

> **NOTE:** There is currently no way to reasonably support dynamic values for specific object types and/or classes.  This is planned for the future, but will require users to implement per-type converters and operation handlers.

You can see a basic breakdown of all the possible types below:

```nim
a := 1
b := 2.0
c := "three"
d := @[]
e := []
f := ()
g := true
h := false
i := nil
```

It is 100% possible to do mixed type arrays/sequences:

```nim
a := [1, "test", 2.0]
```

For object properties, you simply fill in the tuple:

```nim
a := (name: "Bob", age: 47)
```

## Comparison Operators

While dynamic types are, indeed "dynamic" from an implementation standpoint, they are obviously ultimately representations of otherwise strictly typed data.  Because of this, certain decision need to be made about how to handle comparisons that are not otherwise normally possible.  Mininim aims to provide some consistency here, which although comes at the cost of some overhead, tries to avoid some common oddities.

As a general rule, regardless of the dynamic type employed, the inverses should always be true, e.g: if `~1 == ~1.0` then `~1.0 == 1` should also be true.  In order to achieve this, we use a baseline of `not`, `==`, `>` and `<` to further construct `!=`, `>=`, and `<=`, such that:

1. `!=` is equivalent to `not(this == that)`
2. `>=` is equivalent to `(this > that) or (this == that)`
2. `<=` is equivalent to `(this < that) or (this == that)`

For the baseline comparisons of `==`, `>` and `<`, values always convert to the more "primitvie" type of the two.

The most primitive type is `~nil` and is unique in that it is always compared explicitly (without conversion).  Accordingly `~0 != ~nil` and `~false != ~nil`.  Only `~nil == ~nil`.

The next most primitive type is a boolean.  So if either value is a boolean, the non-boolean value will be converted to a boolean first.  If you compare an integer to a boolean, e.g. `~1 == ~true`, then the integer is converted to a boolean first.  This results in `true` as all positive numbers are `true`.

Next are numeric values which includes integers and floats.  If either side is an integer or either side is float, then all non-float values are converted to a float.  Floats will never be converted to integers, this ensures `~1 != ~1.5` and avoids similar oddities that can arise.  In short, numbers are treated with precision.

With all that said, there are cases that require a bit of imagination, but we believe have been implemented in ways which are intuitive, for example:  `~1 < ~true` would be `false`, as would `~1 > ~true`.  As mentioned before, `~1` (or any positive number) is always `true` and it cannot be greater or less than what it is.

For more comprehensive examples, check out [the tests](../tests/testDynamic.nim).

## Mathematical Operations

Unlike comparisons, mathematical operations can often take more liberties.  It's also important to note that while comparisons return **real** `true` and `false` values, mathematical operations always return another dynamic value.

Again, we have tried to be fairly intuitive, but that includes some pedantic adherance to what things are conceptually and this **does** result in differences between what can otherwise look like the same equation.  For example `~1 + ~nil` is `~1` while `~nil + ~1` is `~nil`.  Similar to `/dev/null`, we do not consider `nil` to be simply nothing, but rather the negation of something.  Accordingly, you cannot add to it, but it can subtract from what is.

## Functions and Procedures

It is possible to use dynamic values with many built-in Nim functions/procedures because they can generally be converted to the requisite types automatically.  However, it is possible to register explicit functions for dynamic values which can then be used both in the native Nim context as `dyn` native functions, and also in `mininim/script` evaluations.  Here's an example of a built in function that is registered in the `mininim/dynamic` module itself:

```nim
dyn.register(
    "len",
    proc(this: dyn): dyn =
        if this of nil:
            result = -1
        elif this of array:
            result = toArray(this).len
        elif this of object:
            result = toObject(this).len
        elif this of bool:
            result = if this: 1 else: 0
        elif this of int:
            var
                value: string
                sign: int = 1
            if this < 0:
                value = toString(this)[1..^1]
                sign = -1
            else:
                value = toString(this)

            result = sign * toInt(value.len)
        elif this of float:
            var
                value: string
                sign: int = 1
            if this < 0:
                value = toString(this)[1..^1]
                sign = -1
            else:
                value = toString(this)
            let
                split = value.find('.')

            result = sign * toFloat($split & "." & $(value.len - (split + 1)))
        else:
            result = toString(this).len
)
```

While some of this is standard, of interest might be that `~nil` always has a length of `-1` while floats have a float length equivalent to their digits on either side of the decimal, e.g. `~3.14159` would have a length of `~1.5`.  Similarly, integers have a length equal to their digits.  In both cases, if the number is negative, its length is negative.
