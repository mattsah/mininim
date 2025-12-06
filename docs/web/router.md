# Router

The Mininim `mininim/router` module is a sub-module of the `mininim/web` module and is designed to provide both the router middleware as well as a means by which to register routes in your application.

## Common

```nim
import
    mininim,
    mininim/web/router
```

## Routes

```nim
shape Router: @[
    Route(
        path: "/users/{id:[1-9][0-9]*}",
        methods: @[HttpGet],
        call: RouteHook as (
            block:
                let
                    id = request.pathParams["id"]
                    users = this.app.get(Users)
                    user = users.find(id)

                if user == nil:
                    result = Response(status: HttpCode(404))
                else:
                    ...
        )
    )
]
```

## Actions

More often than not you will want to extend the `Action` class:

```nim
type
    GetUser = ref object of Action
        users: Users

begin GetUser:
    method init(users: Users) =
        this.users = users

    method invoke(): Response =
        let
            user = this.users.find(this.get("id"))

        if user == nil:
            result = Response(status: HttpCode(404))
        else:
            ...

shape GetUser: @[
    Delegate(
        call: DelegateHook as (
            block:
                result = self.init(
                    users = this.app.get(Users)
                )
        )
    )
    Route(
        path: "/users/{id:[1-9][0-9]*}",
        methods: @[HttpGet]
    )
]
```