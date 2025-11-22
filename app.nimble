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
requires "https://github.com/mattsah/mininim-core.git"
requires "https://github.com/mattsah/mininim-cli.git"
requires "https://github.com/mattsah/mininim-web.git"

# Tasks

task build_dev, "Build the development version with debug and what not":
    exec "nimble build --linetrace:on --stacktrace:on --checks:on --d:debug --verbose"

task build_prod, "Build the production version with optimization":
    exec "nimble build --opt:speed --d:release --verbose"
