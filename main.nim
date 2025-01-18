{. warning[UnusedImport]:off .}

import
    mininim/dic,
    mininim/cli,
    mininim/loader

loader.scan("./local")

var app = App.init(config)
var console = app.get(Console)

quit(console.run())