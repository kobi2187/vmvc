import regex, strutils, tables, sequtils, sugar, options
import parsed_command



const command = r"(?P<command>[a-zA-Z]+($|\s+))"
const subCommands = r"(?P<subs>(([a-zA-Z]+)($|\s+))*)"
const config = r"(?P<configs>((-[A-Za-z0-9]+:[A-Za-z0-9]+)($|\s+))*)"
const fullcmd = re(command & subCommands & config)


proc validateCommand(cmd: string): Option[RegexMatch] =
  assert (cmd.len>0)
  var m: RegexMatch
  result = if cmd.match(fullcmd, m):
    m.some
  else:
    none(RegexMatch)

proc parseCommand*(cmd_and_args: string): ParsedCommand =
  assert (cmd_and_args.len > 0)

  let theText = cmd_and_args.toLowerAscii()
  let subs: seq[string] = @[]
  var cmd = ""
  let configDict = newTable[string, string]()

  let opt = validateCommand(theText)
  let ok = opt.isSome
  if not ok:
    result = asError("validation failed.")

  else: # regex is valid.
    # start parsing: gets the regex groups.
    echo "start parsing: gets the regex groups."
    let match = opt.get
    let cmds = match.group("command")
    if cmds.len > 0:
      var joined = theText[cmds[0]]
      cmd = joined.strip


      let subs = match.group("subs").map(s => theText[s].strip)[
          0].splitWhitespace
      # echo subs
      # only have configs if we have command or command+subs
      let configs = match.group("configs").map(s=>theText[s].strip)[
          0].splitWhitespace
      echo configs
      if configs.len>0:
        for cfg in configs:
          echo cfg
          var pair = cfg.split(':')
          echo pair
          assert(pair.len==2)
          var key = pair[0]
          key.removePrefix({'-'})
          let val = pair[1]
          configDict.add(key, val)

      result = makeParsedCommand(cmd, subs, configDict)
      echo result
    else: result = asError("couldn't find groups in regex")










when isMainModule:
  echo "hi there.... tests:"
