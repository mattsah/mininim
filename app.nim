import
    dotenv,
    mininim/loader,
    mininim/cli

if os.fileExists(".env"):
    dotenv.load()

loader.scan("./local")

var
    app = App.build()
    console = app.get(Console)

quit(console.run())