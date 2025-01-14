# Mininim

Mininim (like: minimum, but with "nim") is a general purpose framework for nim that is designed to make it more approachable for object-oriented programming and fill in some gaps for run-time type information.  This project imports concepts from my work as a PHP developer wherein the ecosystem of available package is highly modular.  The goal here is then to create an extendable application infrastructure that allows for easily adding modules to a given project.  Thereby we enable rapid development of web-based and CLI applications, as well as new modules.

The way this all works is probably some sort of violation of the "Nim way."  I don't care.  There will be _some_ performance degredation.  There will be _minor_ loss of safety.  What's the point of a programming language with such interesting meta-programming features if you can't have fun?

With that all said.  Let's cover some basic concepts.

## HEADS UP

None of this really exists yet.  This is a project i'm working on.  Don't expect to be able to follow any of the instructions.  There's a lot still in play.  But this is the basic concept.  Here's a basic roadmap:

- [x] Implement application template (see: you're looking at it)
- [x] Implement general architecture, DIC, delegate (see https://github.com/mattsah/mininim-core)
- [ ] Implement CLI functionality (see: https://github.com/mattsah/mininim-cli)
- [ ] Implement web/rout functionality with Prologue

## Architecture

Mininim borrows from object oriented programming with a heavy reliance on dependency injection. While an _ultimate_ goal would be to have some sort of auto-wired dependency injection, this is not in the cards without the introduction of far more comprehensive meta-programming.  This is because, as you have probably noted if you came from the OOP world, "classes" don't really exist as a concept in Nim.  And while there's some argument that "classes" don't really exist anywhere and we're all just passing structs as first parameters, there are a few critical differences from more dynamic OOP oriented programming language:

- No Default Constructor Overloading
- No Run-Time "Class" Information (e.g. what are the methods?  what are their arguments?)

### Classes

Mininim uses the `classes` package (at least part of it), found here:  https://github.com/jjv360/nim-classes.  While it's not necessary to use this style, it is heavily used in various internals and packages.  This may get forked into the core and improved later, but for now it has been relative sufficient.  While not strictly necessary, documentation will refer to classes, generally, as objects + associated procs/methods.

Classes look something like this:

```nim
class Console:
    var
        app: App

    method init*(app: var App): void =
        this.app = app

    method run*(): int =
        let command = this.app.config.findAll(Command)

        # Find the command matching the passed args, and execute it
```

In the above example `init()` is our constructor.

### Facets

Facets are ways in which you define extensible features on a given class.  You can think of facets as nodes in an application configuration that tell the application how to operate.  An example of a facet would be the following:

```nim
Delegate(
    builder: proc(app: var App): Console =
        result = Console.init(app)
)
```

This facet tells the application's Dependency Injection Container (DIC) how to build the type it's attached to.  In this case, you can probably determine it's attached to a `Console` type.  However, it's important to note that the class/object types which facets are attached to is not generally defined by the Facet (and certainly not an individual property of the Facet).  For that we need Shapes.

### Shapes

Shapes are comprised of many Facets.  A shape is defined as a sequence of Facets attached to a type:

```nim
shape Console: @[
    ... # Facets
]
```

Combining this with our previous example, we can probably start to make better sense of things:

```nim
shape Console: @[
    Delegate(
        builder: proc(app: var App): Console =
            result = Console.init(app)
    )
]
```

The above code, when combined with the previous class basically tells our application how to construct a new `Console`.  For all this to work though, we need to make use of our Application and Loader.  This is where the magic happens.

### Application and Loader

Let's take a look at how our application template's `main.nim` file could work.  To understand this as well as the development workflow a bit better, we'll begin with the standard `main.nim`:

```nim
{. warning[UnusedImport]:off .}

import
    mininim/dic,
    mininim/loader

loader.scan("./local")

var app = App.init(config)

quit(0)
```


Taking this line by line.

Firstly, we disable unused import warnings

```nim
{. warning[UnusedImport]:off .}
```
In order for Mininim to dynamically load Facets/Shapes, the files need to be imported.  This doesn't mean they're used int the current module, but we need them in there for the initial setup.  While nothing will break if this line is removed, any package/feature you depend on that is not immediately used in the `main.nim` will issue a warning.

Now we import our feature set. The baseline for this is probably always `mininim/dic` and `mininim/cli`, though it could be just `mininim/dic` depending on your use case.

```nim
mininim/dic
```

Provides the `Delegate` Facet as well as teh `app.get()` method for resolving dependencies.

```
mininim/loader
```

The loader provides the `scan()` macro which rescursively scans your application's directory for `.nim` files in order to reigster all Shapes/Facets.  Yes, this literally imports every file in your application.  Deal with it.  If you're not using code, then delete it, we have version control for Christ's sake.

```
loader.scan('./local')
```

Scans literally all files in `local` and imports them.  This causes various Shapes/Facets to be registered int the config.

```nim
var app = App.init(config)
```

Creates our new application instance.  We'll spare you the `quit(0)` line.  Needless to say, that should be replaced with your actual application functionality.  Let's then take a look at how we can start building such functionality in a modular way.

First off, we'll run:

```bash
nimble add mininim_cli
```

In theory, this should download/install the library and add it to our dependencies in our `app.nimble` file.  Putting aside `nimble sync` which seems to be necessary to get half-way functional LSP support, let's add taht to our import statements in the application's `main.nim`:

```
import
    mininim/cli,
    mininim/dic,
    mininim/loader
```

> Note: You should always make sure to import packaged modules prior to the `mininum/loader`.  Such modules can often register "meta-shapes" (shapes of facets) which define default hooks and other values.

Let's now modify our `main.nim` to use the console.  Keeping in mind, we'll still want to scan our application's source directory before this:

```nim
var app = App.init(config)
var console = app.get(Console)

quit(console.run())
```

Now our Minimim application is ready to use the console module.  We can now create a local class and corresponding Shape with the `Command` Facet in something like `local/commands/Entry.nim`:

```nim
class Entry:
    var
        app: App

    method init*(app: var App): void =
        this.app = app

    method execute*(): int =
        # Do things
        result = 0

shape Entry: @[
    Delegate(
        builder: proc(app: var App): Entry =
            result = Entry.init(app)
    ),
    Command(
        name: "",
        description: "Entry command that does things by default"
    )
]
```