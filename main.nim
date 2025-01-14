import
    mininim/loader,
    mininim/dic,
    mininim/cli

var app: App = App.init(loader.config)
var console: Console = app.get(Console)

console.run()

quit 0