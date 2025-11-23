# Script

The `mininim/script` module provides a simple expression language that can be interpreted at runtime as a string input.  It makes use of the `mininim/dynamic` module to interpret and return `dyn` typed variables which support dynamic runtime operations which are effectivley "typeless."

## Evaluating

```nim
var
    four = Script.eval("two+two", (two: 2))
```