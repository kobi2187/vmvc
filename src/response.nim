import err_type
type Response* = tuple[ok:bool, why:string, error:ErrorType]
proc ok*:Response = (true, "",ErrorType.None)
