import marshal, options
import response, err_type

type SimplifiedData* = object
  part*: string
  concise*: string
  passedFromUser*: bool
  objectType*: string

proc newSimplifiedData*(part: string, concise: string): SimplifiedData =
  result.part = part
  result.concise = concise
  result.passedFromUser = true

proc newSimplifiedData*[T](part: string, obj: T): SimplifiedData =
  result.part = part
  result.passedFromUser = false
  result.concise = $$obj
  result.objectType = $typeof(T)
    # result.objectType = none(string)

type VResult* = (Option[SimplifiedData], Response)


proc worked*(sd: SimplifiedData): VResult =
  # echo "WORKED - DATA: ", sd.concise
  result = (some(sd), ok())
proc failed*(resp: Response): VResult =
  result = (none(SimplifiedData), resp)
proc failed*(e: ErrorType, why: string = ""): VResult =
  result = failed(newResponse(false, why, e))
proc failed*(why: string): VResult = failed(Other, why)
