import
    mininim,
    mininim/dic

class Command of Facet:
    var name*: string
    var description*: string

class Console:
    method run*(): void =
        echo "Hello Mininim!"

shape Console: @[
    Delegate(
        hook: proc(app: var App): Console =
            result = Console.new()
    )
]