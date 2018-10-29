import unittest, tables
import vmvc/parsing_utils

suite "parsing utils":
  echo "starting"
  setup:
    discard

  teardown:
    discard

  test "just command":
    let ex1 = parseCommand("exit")
    echo ex1
    assert ex1.error.ok
    check ex1.command == "exit"


  test "cmd and sub":
    let ex2 = parseCommand("app about") # cmd sub
    echo ex2

    assert ex2.error.ok
    check ex2.command == "app"
    check ex2.subCommands == @["about"]

  test "cmd + config":
    let ex3 = parseCommand("init -start:quiet") # cmd config
    assert ex3.error.ok
    check ex3.command == "init"
    check ex3.arguments == {"start": "quiet"}.newTable

  test "cmd + sub 1,2,3 + config":
    let ex4 = parseCommand(
        "convert audio for sure -input:mp3 -output:wav -bitrate:224") # cmd sub1 sub2 sub3 configs
    assert ex4.error.ok

    check ex4.command == "convert"
    check ex4.subCommands == @["audio", "for", "sure"]
    check ex4.arguments == {"input": "mp3", "output": "wav",
        "bitrate": "224"}.newTable



  echo "finished"
