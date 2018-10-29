type ErrorType* {.pure.} = enum
  None, Uninitialized, Parse, Validation, IO, UnknownCommand, UnknownSubCommand, UnknownConfigKeys, BadValue,ValueNotInRange
