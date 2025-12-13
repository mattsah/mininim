import
    mininim,
    mininim/dic,
    mininim/templates,
    unittest

suite "templates":
    test "parse and render":
        var
            app = App.init()
            engine = app.get(TemplateEngine)

        let
            plate = engine.loadFile("assets/testTemplates.html")

        echo plate.render()
