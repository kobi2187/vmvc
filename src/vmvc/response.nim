import err_type

type Response* = object
  ok*: bool
  why*: string
  error*: ErrorType

proc newResponse*(ok: bool, why: string, error: ErrorType): Response =
  result.ok = ok
  result.why = why
  result.error = error


proc ok*(): Response = newResponse(true, "", ErrorType.None)
