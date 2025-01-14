import
    mininim,
    mininim/cli

class Serve:
    method execute*(app: var App): int =
        result = 0

shape Serve: @[
    Command(
        name: "serve",
        description: "Start the HTTP Server"
    )
]