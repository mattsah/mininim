# Package

version       = "1.0"
author        = "Matthew J. Sahagian"
description   = "A new awesome nimble package"
license       = "MIT"
binDir        = "bin"
installExt    = @["nim"]
bin           = @["main"]
namedBin      = {"main": "mininim"}.toTable

# Dependencies

requires "nim >= 2.2.0"
requires "mininim >= 0.1.0"
