import
    mininim,
    mininim/cli

type
    Home = ref object of Class

begin Home:
    method execute*(console: Console): int {. base .} =
        case console.getOpt("l", "language"):
            of "en":
                echo fmt """Hello {console.getArg("name")}!"""
            of "es":
                echo fmt """Hola {console.getArg("name")}!"""
            of "fr":
                echo fmt """Bonjour {console.getArg("name")}!"""

        result = 0

shape Home: @[
    Command(
        name: "welcome",
        description: "Show the welcome message",
        args: @[
            Arg(
                name: "name",
                require: true,
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
