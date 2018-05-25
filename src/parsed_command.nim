import tables

type ErrorType* {.pure.} = enum
  None, Uninitialized, Parse, Validation, IO, UnknownCommand, UnknownSubCommand, UnknownConfigKeys, BadValue,ValueNotInRange

type Response* = tuple[ok:bool, why:string, error:ErrorType]
proc ok*:Response = (true, "",ErrorType.None)

type ParsedCommand* = object
  command : string
  subCommands : seq[string] #not nil
  arguments : TableRef[string,string]
  error: Response
  id : string #make it read only. How?

proc asError*(why: string) : ParsedCommand =
  result.error=(false,why,ErrorType.Validation)

proc hasArgs*(p:ParsedCommand) : bool = (p.arguments.len > 0)
proc hasSubCmds*(p:ParsedCommand) : bool = (p.subCommands.len > 0)
proc isOnlyCmd*(p:ParsedCommand) : bool = (not p.hasSubCmds() and not p.hasArgs())
  
  
import uuids

proc initParsedCommand*(cmd:string; sub:seq[string] = @[]; args:TableRef[string,string] = newTable[string,string]()) : ParsedCommand =
  result.error = ok()
  result.id = $genUUID()
  result.command = cmd;
  result.subCommands = if sub.isNil: @[] else: sub
  result.arguments = if args.isNil: newTable[string,string]() else: args
