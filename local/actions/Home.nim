import
    mininim,
    mininim/web/router,
    mininim/templates

type
    Home* = ref object of AbstractAction

begin Home:
    method invoke*(): Response =
        discard
        let name = this.get("name", "Friend");

        result = this.html("resources/pages/home.html", (name: name))

shape Home: @[
    Route(
        path: "/{name:.*}",
        methods: @[HttpGet]
    )
]
