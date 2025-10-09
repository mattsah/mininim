{. warning[UnusedImport]:off .}

import
    dotenv,
    mininim/loader,
    mininim/dic,
    mininim/cli

dotenv.load()
loader.scan("./local")

var
    app = App.init(config)
    console = app.get(Console)

quit(console.run())