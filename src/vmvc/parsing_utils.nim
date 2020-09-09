# import regex
import strutils, tables, sequtils, sugar, options
import parsed_command

const command = r"(?<command>[a-zA-Z]+($|\s+))"
const subCommands = r"(?<subs>(([a-zA-Z0-9]+)($|\s+))*)"
 # const config = r"(?<configs>((-[A-Za-z0-9]+:[.A-Za-z0-9]+)($|\s+))*)"
 # const config = r"(?<configs>((\s*-[A-Za-z0-9]+:[.A-Za-z0-9\s]+)($|\s+))*)"
const config = r"(?<configs>((\s*-[A-Za-z0-9]+:[^-]+)($|\s+))*)"


import nre

const fullcmd_str: string = command & subCommands & config
let fullcmd = re(fullcmd_str)


proc validateCommand(cmd: string): Option[RegexMatch] =
  assert (cmd.len > 0)
  # echo cmd
  # let caps = cmd.match(fullcmd).get.captures
  # echo caps["command"]
  # echo caps["subs"]
  # echo caps["configs"]
  result = cmd.match(fullcmd)



proc parseCommand*(cmd_and_args: string): ParsedCommand =
  assert (cmd_and_args.len > 0)

  let theText = cmd_and_args.toLowerAscii().replace(" --", " -")
  var subs: seq[string] = @[]
  var cmd = ""
  let configDict = newTable[string, string]()

  let opt = validateCommand(theText)
  if opt.isNone:
    result = asError("validation failed for command: `" & theText & "`")
    return
  else: # regex is valid.
    # start parsing: gets the regex groups.
    # echo "start parsing: gets the regex groups."
    let matches = opt.get
    # echo matches
    let tcmds = matches.captures().toTable
    # echo tcmds
    if tcmds.hasKey("command"):
      cmd = tcmds["command"]
      # echo "CMD:" & cmd

      if tcmds.hasKey("subs"):
        subs = tcmds["subs"].strip.splitWhitespace
        # echo subs
      # only have configs if we have command or command+subs
      if tcmds.hasKey("configs"):
        # echo "BEFORE ", tcmds["configs"]
        let configs = tcmds["configs"].split("-")
        # echo "CONFIGS ", configs

        if configs.len > 0:
          for cfg in configs:
            if cfg.len > 0:
              # echo cfg
              var pair = cfg.split(':')
              # echo pair
              assert(pair.len == 2)
              var key = pair[0]
              key.removePrefix({'-'})
              let val = pair[1]
              configDict.add(key, val)
    else: result = asError("couldn't find groups in regex")
  result = makeParsedCommand(cmd.strip, subs, configDict)
  # echo result

