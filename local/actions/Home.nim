import
    mininim,
    mininim/cli,
    mininim/web,
    mininim/web/router

type
    Home = ref object of Class

begin Home:
    method execute*(console: Console): int {. base .} =
        echo "Hello Mininim!"
        result = 0

    method invoke*(): Response {. base .} =
        result = (
            status: 0,
            headers: emptyHttpHeaders(),
            stream: newStringStream("Hello Mininim!")
        )

shape Home: @[
    Command(
        name: "welcome",
        description: "Show the welcome message"
    ),
    Route(
        path: "/",
        methods: @[HttpGet]
    )
]
