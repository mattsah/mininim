import
    mininim,
    mininim/cli

type
    Welcome* = ref object of Process

begin Welcome:
    method execute*(console: Console): int =
        let name = console.getArg("name", "Friend")

        case console.getOpt("l", "language"):
            of "es":
                echo fmt """Hola {name}!"""
            of "en":
                echo fmt """Hello {name}!"""
            of "fr":
                echo fmt """Bonjour {name}!"""

        result = 0

shape Welcome: @[
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
