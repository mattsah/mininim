import
    mininim,
    mininim/web/router,
    mininim/templates

type
    Home* = ref object of Action

begin Home:
    method invoke*(): Response =
        let name = this.get("name", "Friend");

        result = this.html("resources/pages/home.html", (name: name))

shape Home: @[
    Route(
        path: "/{name:.*}",
        methods: @[HttpGet]
    )
]
