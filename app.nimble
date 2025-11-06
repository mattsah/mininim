# Package

version       = "1.0"
author        = "Matthew J. Sahagian"
description   = "Sample/Testing Mininim Application"
license       = "MIT"
binDir        = "bin"
installExt    = @["nim"]
bin           = @["app"]
namedBin      = {"app": "app"}.toTable

# Dependencies

requires "nim >= 2.2.0"
requires "dotenv >= 2.0.0"
requires "mininim_core >= 0.1.0"
requires "mininim_cli >= 0.1.0"
requires "mininim_web >= 0.1.0"

# Tasks

task build_dev, "Build the development version with debug and what not":
    exec "nimble build --debugInfo --linetrace:on --stacktrace:on --checks:on --d:debug --verbose"

task build_prod, "Build the production version with optimization":
    exec "nimble build --opt:speed --passC:-flto --passL:-flto --d:release --verbose"