# Package

version       = "0.0.2"
author        = "Kobi Lurie"
description   = "a skeleton/structure for a variation on the mvc pattern, similar to dci. For command line and gui programs. it's a middle ground between rapid application development and handling software complexity."
license       = "MIT"
srcDir        = "src"
skipDirs = @["tests"]
# web = "https://github.com/kobi2187/vmvc"
# url = "https://github.com/kobi2187/vmvc"
# Dependencies

requires "nim >= 0.18.1"
requires "uuids >= 0.1.10", "regex >= 0.10.0"

# Tasks

task test, "Run tests":
  exec "nim c -r tests/test_parsing_utils.nim"