import
    mininim,
    mininim/cli


#[
    A simple contrived "action" example.
]#
class Home:
    var
        console: Console

    method execute*(app: var App): int =
        echo "Hello Mininim!"
        result = 0

    method setConsole*(console: var Console): void =
        this.console = console

shape Home: @[
    Command(
        name: "welcome",
        description: "Welcome Message"
    )
]
