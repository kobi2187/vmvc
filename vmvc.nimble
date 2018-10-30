# Package

version       = "0.0.1"
author        = "Kobi Lurie"
description   = "a skeleton/structure for a variation on the mvc pattern, similar to dci. For command line and gui programs. it's a middle ground between rapid application development and handling software complexity."

#"Attempting to achieve that by having simple control flow and a focal point on the controller side, to handle user interactions, with the benefit that we can add actions before or after the user request has been applied. user requests are text commands. The domain objects are all \"dumb\" structs, and the views only know how to draw themselves. Once you have these two parts, and the gui is created, you can advance with unit tests and controller area code, though you should separate all functionality to roles, aka managers. instantiate them and use them in the controller. The last part is basically a large switch-case (the controller is mostly a router here). the views can be any gui you want, command line, or a text user interface. the switch case operates on a parsed command."

license       = "MIT"
srcDir        = "src"
skipDirs = @["tests"]
web = "https://github.com/kobi2187/vmvc"
url = "https://github.com/kobi2187/vmvc"
# Dependencies

requires "nim >= 0.18.1"
requires "uuids >= 0.1.10", "regex >= 0.10.0"

# Tasks

task test, "Run tests":
  exec "nim c -r tests/test_parsing_utils.nim"