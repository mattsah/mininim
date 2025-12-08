# Package

version       = "1.0"
author        = "Matthew J. Sahagian"
description   = "Sample/Testing Mininim Application"
license       = "MIT"
binDir        = "bin"
installExt    = @["nim"]
bin           = @["app"]
namedBin      = {"app": "app"}.toTable

# Tasks

task analyze, "Build the debug version with debug":
    exec "nimble build --debugger:native --linetrace:on --stacktrace:on --checks:on --d:debug=${debug:-1} --verbose"

task testing, "Build the testing version with no debug":
    exec "nimble build --linetrace:on --stacktrace:on --checks:on --verbose"

task release, "Build the production version with optimization":
    exec "nimble build --opt:speed --d:release --verbose"

# Dependencies

requires "nim >= 2.2.0"
requires "dotenv >= 2.0.0"
requires "https://github.com/primd-cooperative/mininim-core.git"
requires "https://github.com/primd-cooperative/mininim-cli.git"
requires "https://github.com/primd-cooperative/mininim-web.git"
