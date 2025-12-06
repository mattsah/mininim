import
    mininim,
    mininim/dic,
    mininim/xmltemplates,
    unittest

suite "xml-templates":
    test "parse and render":
        var
            app = App.init()
            engine = app.get(XmlEngine)

        let
            plate = engine.loadFile("tests/assets/testXmlTemplates.html")

        echo plate.render()
