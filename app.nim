import
    dotenv,
    mininim/loader,
    mininim/dic,
    mininim/cli

if os.fileExists(".env"):
    dotenv.load()

loader.scan(currentSourcePath().parentDir / "local")

var
    app = App.init()
    console = app.get(Console)

quit(console.run())
