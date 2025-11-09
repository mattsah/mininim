import
    dotenv,
    mininim/dic,
    mininim/loader,
    mininim/cli

if os.fileExists(".env"):
    dotenv.load()

loader.scan("./local")

var
    app = App.init()
    console = app.get(Console)

quit(console.run())