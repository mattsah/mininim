# Mininim

Mininim (like: minimum, but with "nim") is a general purpose framework for the Nim programming language that is designed for:

- Familiar-ish OOP paradigms (this, super, self, proto)
- Modularity and extensibility via a novel "plugin" approach.
- Rapid development with terse, but readable, code

> **NOTE:** All code is currently alpha state and is not published through official package channels.  If you want to test Mininim or help development, see the [development section](#development)

## Introduction

Mininim works by defining classes and decorating them with what we call "**facets**."  One or more facets comprises the "**shape**" of the class and, in turn, augments its behaviors and features within your overall application.

Put more simply, you can think of the shape and facets as a configuration for the class which defines how it can be used by the system or other parts of the system.

A simple example of a facet from the `mininim/web/router` module looks like this:

```nim
Route(
    path: "/{name:.*}",
    methods: @[HttpGet]
)
```

As you can probably guess, this facet indicates that the class it's added to is capable of serving an HTTP Get request made to a URL matching the pattern specified in its `path` property.

Let's take a look at how this sits in the context of our `local/actions/Home.nim` file (in this example repository) to get a better understanding:

```nim
import
    mininim,
    mininim/web/router

type
    Home = ref object of Action

begin Home:
    method invoke*(): Response =
        let name = this.request.get("name", "Friend");

        result = Response(status: HttpCode(200), stream: newStringStream(
            fmt "Hello {name}"
        ))

shape Home: @[
    Route(
        path: "/{name:.*}",
        methods: @[HttpGet]
    )
]
```

Here we can see that by adding the `Route` facet to our `Home` class's shape, we're able to handle routed requests via our `invoke()` method on the corresponding class.  Digging a little bit deeper, we can take a look at the shape of the `Route` facet, itself, to see how the dots are being connected:

```nim
shape Route: @[
    Hook(
        call: proc(router: Router, request: Request): Response {. closure .} =
            let
                action = this.app.get(shape)

            action.request = request
            action.router = router

            result = action.invoke()
    )
]
```

Yes, our facets have facets.  Admittedly, the `Hook` facet is a particularly special one.  The important part, however (for now), is understanding how the `Home` action actually gets instantiated and called, which leads us to our next topic:

#### Dependency Injection

One of the key components of Mininim is how it enables service location and dependency injection.  While, at present, there is no support for automatic dependency injection (though it is planned), the framework does support a notion of delegates as well as singletons.  A good example of a class which has both facets is the `Router`.  Located in the `mininim/web/router` module, here is its shape:

```nim
import
    ...,
    mininim,
    mininim/dic,
    mininim/web,
    ...

shape Router: @[
    Shared(),
    Delegate(
        call: proc(): shape {. closure .} =
            result = shape.init()

            for route in this.app.config.findAll(Route):
                result.add(route)

			...
    ),
    ...
]
```

##### Delegate

A `Delegate` facet is responsible for providing a factory which can be called to build the dependency when it is created via `App.get()`.  In the example above, when  `app.get(Router)` is called in another context, the application instance will use the `call` function defined on `Router`'s  `Delegate` to build the router.  In this example that function is responsible for:

- Creating the new `Router` instance: `result = shape.init()`.  The `shape` keyword will be resolved to the `Router` class type during macro compilation, so this would be equivalent to calling `result = Router.init()` .
- Locating any `Route` facets registered in the configuration: `for route in this.app.config.findAll(Route)`.  This is where it would find our previous example on the `Home` action.
- Adding all discovered `Route` facets to the `Router` instance so it knows what routes are available and has the means to call them.

##### Shared

By adding the `Shared` facet, we additionally can tell our `App` instance to always return the same instance when using `App.get()` for the specified type.  This effectively allows you to create singletons with ease.  It should be noted, however, that all `Shared` instances are created at application startup and, accordingly, are not unique per thread and are not suitable for lazy instantiation.

#### Building Blocks

The goal of Mininim is to provide consistent building blocks for creating complex and dynamic applications.  In addition to all of the examples above, there are basic implementation of the following:

- Console and Commands
- HttpServer (based on mummy) and Middleware
- General Object-Oriented Programming

By providing these core features, Mininim already covers many use cases with its default application entry point which can be seen in the `app.nim` file located in the root of this repository:

```nim
import
    dotenv,
    mininim/loader,
    mininim/dic,
    mininim/cli

if os.fileExists(".env"):
    dotenv.load()

loader.scan("./local")

var
    app = App.init()
    console = app.get(Console)

quit(console.run())
```

When our application is compiled the `loader.scan("./local")` macro will import all `.nim` files in our `local` folder, registering their shapes and creating the compile-time configuration.  In addition to the files located in the `local` directory, it's possible to create independent packages which, when imported by those files, will also have their shapes registered.

The result is a relatively simple auto-discovery and registration system that allows for increased extensibility and limited integration overhead.

## Object-Oriented Features

As mentioned and demonstrated in the examples above, Mininim is not just a low-key plug-in system, but a more comprehensive addition to the language that offers familiar OOP paradigms.  This functionality is added through Nim's powerful meta-programming features and is designed to reduce repetition and verbosity as well as open up new possibilities for certain run-time features in the future.  You can make use of these features regardless of whether or not you're using Mininim's application or facet system.

This section assumes you're already somewhat familiar with Object-Oriented Programming.  To get started just:

```nim
import mininim
```

While the remainder of this section will show various code snippets as separate sections, you should take note that it's still good practice to effectively forward declare all your types in a single block.  Accordingly, the overall structure of a Mininim enabled-module tends to look something like this:

```nim
type
    ...

begin [type]:
    ...

shape [type]:
    ...

begin [type]:
    ...

shape [type]:
    ...

...
```

That said, it's possible to organize your code differently so long as you're accounting for necessary declaration of dependencies before use and visibility.  Unless you're implementing your own `Hook` shaped facets, standard rules apply and there should be no significant gotchas.

#### Defining a Class

Classes are defined by creating reference object of type `Class`:

```nim
type
    Animal* = ref object of Class
        noise: string
```

#### Constructors

You can define a constructor for your class by adding an `init` method to the `begin` macro:

```nim
begin Animal:
    method init*(noise: string): void {. base .} =
        this.noise = noise

    method speak*(message: string): string {. base .} =
        result = fmt "{message}, {this.noise}!"
```

#### This

The `this` variable is automatically pre-pended to all `method` and `proc` declarations in the body of the `begin` macro unless they are decorated with the `{. static .}` pragma.  Similar to most other Object-Oriented languages, the `this` keyword will be the instance upon which the method or procedure is being called.

#### Extending a Class

Extending a class is as simple as creating a new type which is a reference object of the parent class type:

```nim
type
    Dog* = ref object of Animal
        name: string
        age: int
```

#### Super

When you overload a base method, you can use the `super` keyword to call the parent class's implementation(s) of methods.  Because methods and procedures support parameter overloads, you can you can overload the constructor with different parameters:

```nim
begin Dog:
    method init*(name: string, age: int): void {. base .} =
        this.name = name
        this.age  = age
        super.init("woof")

    method speak*(message: string): string =
        result = fmt "{this.name}: {super.speak(message)}"
```

Note, however, because the signature differs the new method requires it be decorated with the `{. base .}` pragma.

#### Static Features

It's possible to declare a procedure as static, which, unlike a non-static equivalent will have the `self` parameter automatically prepended and typed as `typedesc[<type>]` where the `<type>` is the concrete class name.  This, for example is used on the default `build()` method for the `Delegate` facet when no custom `call` property is added:

```nim
proc build(app: App): self {. static .}=
    result = self.init()
```

##### Self

The `self` keyword can be used in both static procedures as well as non-static procedures and will always refer to the concrete type.

##### Proto

The `proto` keyword is the equivalent of the `super` keyword, but in the static space.  This will always refer to the parent type, so in the case of `Dog` it would be the `Animal` type.

##### Abstract

You can indicate a procedure or method is abstract and should be implemented by it's children by adding the `{. abstract .}` pragma.  At present, this will simply add `discard` to the body, but in the future, it is intended to actually error if the child does not have the require implementation.

## Testing and Development

Clone this repo:

```
git clone https://github.com/mattsah/mininim
cd mininim
```

Install dependencies:

```
nimble setup
```

To work on related packages:

```
nimble develop https://github.com/mattsah/mininim-core.git
nimble develop https://github.com/mattsah/mininim-cli.git
nimble develop https://github.com/mattsah/mininim-web.git
nimble develop
```

Build

```
nimble testing
```

Run
```
bin/app welcome
```

or Run

```bash
bin/app serve
```

