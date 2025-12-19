#
# This a percy package. The `version` key is intentionally missing to
# break nimble. To install:
#
# - Install Percy (see: https://github.com/mattsah/percy)
# - percy install
# - nim build
#

author = "Matthew J. Sahagian"
binDir = "bin"

requires "nim >= 2.2.6"
requires "dotenv >= 2.0.0"
requires "mininim_core"
requires "mininim_cli"
requires "mininim_web"

