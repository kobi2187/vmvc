type ErrorType* {.pure.} = enum
  None, Uninitialized, Parse, Validation, IO, UnknownCommand, UnknownSubCommand,
      UnknownConfigKey, BadValue, ValueNotInRange, MissingKey, MissingConfig,
          Other, NotImplemented

