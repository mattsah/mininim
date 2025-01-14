import
    mininim,
    mininim/cli,
    mininim/web

#[
    A simple contrived "action" example.
]#
class Home:
    #[
        This gets executed when `minim` is run.
    ]#
    method execute*(): int =
        echo "Hello Minim!"
        result = 0

    #[
        This gets executed when `minim serve` is run (set up elsewhere) and you GET `/` on the running server.
    ]#
    method handle*(): string =
        result = ""

#[
    Shape is used to register classes as providing certain functionality to the application via Facets.  Shown below are examples for `Home` above handling routing or an empty sub-command through the addition of the `Route` and `Command` Facets.  Other examples might include:

        - Share (Enforces the class to be treated as a singleton for dependency resolution)
        - Delegate (Factory callback for constructing dependencies)
        - Provider (Post-construction callbacks applied to concept implementers)
        - Implements (Identifies concepts implemented by the class)
        - Middleware (Registers an instance of the class as web-based middleware)
        - Intermediate (Registers an instance of the class as cli-based middleware)
]#
shape Home: @[
    Route(
        path: "/",
        methods: @[HttpGet]
    ),
    Command(
        name: "",
        description: "Welcome to Minim"
    )
]