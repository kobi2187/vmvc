
# view will get a json object. (JsonNode ?), instead of arbitrary format as in original version.
# TODO(FUTURE):feature set can be set of enum, but maybe have that as optional mixins (or decorators) that the user can peruse.
# TODO(FUTURE): can we pass the user provided "parts" enum? or is it just a set of strings? prefer compile time checking.
# TODO(FUTURE): need to port the generic view code as well, for command line, test, and gui.
# TODO(FUTURE): provide the controller features, such as log, replay, profiler, etc, that "sit" in the controller focal point.
# TODO(FUTURE): make some samples, show how it's intended to be used.









import vmvc/[parsed_command, response]
import json, tables, sets

type SimpleData* = tuple[part: string, data: JsonNode]


type IModel* = concept domain
  domain.make_simple_data(): JsonNode

type IView* = concept view
  view.setupUi()
  view.redrawAll(drawing_data: seq[SimpleData]) # screen_part, format
  view.redrawPart(data: SimpleData)
  view.requestUpdate()
  view.notify(note: string)
  view.start()
  view.showErr(resp: Response)
  view.doExit()

# api for view
type IController* = concept c
  c.requestReload*()
  c.requestPartialReload*(part: string)
  c.load()
  c.performAction(cmd: string): Response


type IRole* = concept role
  var tasked_with*: string
  # check that the environment allows its operation, e.g a logger will check ability to write to disk.
  role.checkFeasability()

type IControllerSpec* = concept c
  c.beforeAction(cmd_and_args: ParsedCommand)
  c.customAction(cmd_and_args: ParsedCommand): Response
  c.afterAction(cmd_and_args: ParsedCommand)

  c.attachView(v1: IView)
  c.detachView(v1: IView)

  var roles: set[IRole]

  c.notifyViews(note: string)
  c.sendErrToViews(err: Response)
  c.updateViews()
  c.updateViewPart(v1: IView, data: SimpleData)
  c.getDataForPart(part: string): SimpleData # may create later a Part enum and move it as generic parameter. (in concept declaration)
  c.doSaveState()

