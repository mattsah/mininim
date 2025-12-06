# Web

The Mininim web module is designed to provide the basics for web-based applications.  This includes a server which is wrapped around Mummy (https://github.com/guzba/mummy), a modern Request/Response model, and the basic Middleware functionality.

## Common

To work with web components, make sure to import the following:

```nim
import
    mininim,
    mininim/web
```

## Requests

The `Request` object contains information about the incoming HTTP request and can be modified by middleware before being passed along:

```nim
if request.httpMethod == HttpPost:
    ...
```

### URI

The `uri` property on the `Request` object is a `Uri` object from `std/uri` (https://nim-lang.org/docs/uri.html#Uri).

## Middleware

```nim
shape HttpServer: @[
    Middleware(
        name: "my-middleware",
        priority: 100,
        call: MiddlewareHook as (
            block:
                #
                # Modify the request, return early response, etc.
                # To invoke the next middleware simply call:
                #
                next(request)
        )
    )
]
```