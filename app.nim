import
    dotenv,
    mininim/loader,
    mininim/dic,
    mininim/cli,
    mininim/mdlw/public404

if os.fileExists(".env"):
    dotenv.load()

loader.scan("./local")

var
    app = App.init()
    console = app.get(Console)

quit(console.run())