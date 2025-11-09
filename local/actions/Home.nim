import
    mininim,
    mininim/cli,
    mininim/web/router

type
    Home* = ref object of Action

begin Home:
    method execute*(console: Console): int {. base .} =
        let name = console.getArg("name", "Friend")

        case console.getOpt("l", "language"):
            of "es":
                echo fmt """Hola {name}!"""
            of "en":
                echo fmt """Hello {name}!"""
            of "fr":
                echo fmt """Bonjour {name}!"""

        result = 0

    method invoke*(): Response =
        let name = this.request.get("name", "Friend");

        result = Response(status: HttpCode(200), stream: newStringStream(
            fmt "Hello {name}"
        ))

shape Home: @[
    Route(
        path: "/{name:.*}",
        methods: @[HttpGet]
    ),
    Command(
        name: "welcome",
        description: "Show the welcome message",
        args: @[
            Arg(
                name: "name",
                require: false,
                description: "The name of the person to say hello to"
            )
        ],
        opts: @[
            Opt(
                flag: "l",
                name: "language",
                values: @["en", "es", "fr"],
                default: "en",
                description: "The language to say hello in"
            )
        ]
    )
]
