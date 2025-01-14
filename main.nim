{. warning[UnusedImport]:off .}

import
    mininim/dic,
    mininim/loader

loader.scan("./local")

var app = App.init(config)

quit(0)