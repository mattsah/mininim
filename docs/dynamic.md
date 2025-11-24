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

If you absolutely feel the need to prevent mutations, you can use the "literal" syntax, which is otherwise mostly used as a shorthand in, well, "literal" contexts:

```nim
let
    numbers = ~[]
```

## Supported Types

Dynamic values do not support specific object/class types at this time.  They do, however, effectively support scalar types as well as strings, arrays/sequences, and "anonymous objects" of sorts as represented by tuples.

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

It is possible to do mixed type arrays/sequences:

```nim
a := [1, "test", 2.0]
```

For object properties:

```nim
a := (name: "Bob", age: 47)
```