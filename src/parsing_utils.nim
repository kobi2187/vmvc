import regex, strutils, tables, parsed_command

const command = r"(?P<command>[a-zA-Z]+($|\\s+))"
const subCommands = r"(?P<subs>(([a-zA-Z]+)($|\\s+))*)"
const config = r"(?P<configs>((-[A-Za-z0-9]+:[A-Za-z0-9]+)($|\\s+))*)"
const fullcmd = re(command & subCommands & config)
# const oneConfig = re"(-[A-Za-z0-9]+:[A-Za-z0-9]+)"
# const oneCmd = re"[a-zA-Z]+"

#TODO: try first with maybes. add ? to sub and config. see if I can extract that from the regex.
#TODO: port the tests!!

proc isValidCommand(cmd : string) : bool =
  assert (not cmd.isNil and cmd.len>0)
  result = cmd.match(fullcmd).isSome

proc parseCommand*(cmd_and_args : string) : ParsedCommand =
  assert (cmd_and_args.len > 0)

  let lower = cmd_and_args.toLowerAscii()
  let cmd = ""
  let subs:seq[string] = @[]
  let configDict = newTable[string,string]()
        
  if not isValidCommand(lower):
    var why = "validation failed."
    var res = asError(why)
    return res
  else:
    # start parsing: gets the regex groups.
    var matched_groups = lower.match(fullcmd)
    if matched_groups.isSome:
      let match = matched_groups.get
      echo match
      let cmds = match.group("command")
      if cmds.len > 0:
        var joined = lower[cmds[0]].join(" ")
        joined.removePrefix({' '})
        joined.removeSuffix({' '})
        let cmd = joined
        echo cmd

      let subs = match.group("subs")
      if subs.len>0:
        var sub = lower[subs[0]].join(" ")
        sub.removePrefix({' '})
        sub.removeSuffix({' '})
        echo sub
      
      let configs = match.group("configs")
      if configs.len>0:
        var cfgs = lower[configs[0]].join(" ")
        cfgs.removePrefix({' '})
        cfgs.removeSuffix({' '})
        echo cfgs

          
        if (cfgs.len > 0):
          for cfg in cfgs.splitWhitespace():
            echo cfg
            var pair = cfg.split(':')
            echo pair
            assert(pair.len==2)
            var key = pair[0]
            key.removePrefix({'-'})
            let val = pair[1]
            configDict.add(key,val)
        
  result = initParsedCommand(cmd, subs, configDict)

  







when isMainModule:
  echo "hi there.... tests:"