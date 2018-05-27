import tables
import response, err_type
# import err_type


type ParsedCommand* = object
  command* : string
  subCommands* : seq[string] #not nil
  arguments* : TableRef[string,string]
  error*: Response
  id : string #make it read only. How?
proc id*(p:ParsedCommand):string = p.id

proc asError*(why: string) : ParsedCommand =
  result.error=(false,why,ErrorType.Validation)

proc hasArgs*(p:ParsedCommand) : bool = (p.arguments.len > 0)
proc hasSubCmds*(p:ParsedCommand) : bool = (p.subCommands.len > 0)
proc isOnlyCmd*(p:ParsedCommand) : bool = (not p.hasSubCmds() and not p.hasArgs())
  
  
import uuids

proc makeParsedCommand*(cmd:string; sub:seq[string] = @[]; args:TableRef[string,string] = newTable[string,string]()) : ParsedCommand =
  
  result.error = ok()
  result.id = $genUUID()
  result.command = cmd;
  result.subCommands = sub # if sub.isNil: @[] else: sub
  result.arguments = args #if args.isNil: newTable[string,string]() else: args
