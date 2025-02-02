{. warning[UnusedImport]:off .}

import
    dotenv,
    mininim/loader,
    mininim/dic,
    mininim/cli,
    mininim/web,
    mininim/web/router

dotenv.load()
loader.scan("./local")

var
    app = App.init(config)
    console = app.get(Console)

quit(console.run())