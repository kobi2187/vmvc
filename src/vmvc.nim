# view will get a json object. (JsonNode ?)
# [v] regex lib has captured groups
# feature set can be set of enum, but maybe have that as optional mixins (or decorators) that the user can peruse.
# implement the classes - don't think about interface specs right now.
# do concepts where user has to build his own, but not in the internal system.
# parts enum can be a set of strings. although view and controller should have the exact same strings (which is why a compiled enum prevented spelling mistakes) perhaps we can find a way to initialize or validate this, or even just trust the user that it'll work. maybe a test by the controller that every part updates itself... i don't know. we'll see later. for now, set[string]









import libvmvc/[parsed_command, response]
# {.experimental: "notnil".}
import json, tables, sets

type SimpleData* = tuple[part: string, data: JsonNode]


type IModel* = concept domain
  domain.make_simple_data() is JsonNode

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

  var roles: seq[IRole]

  c.notifyViews(note: string)
  c.sendErrToViews(err: Response)
  c.updateViews()
  c.updateViewPart(v1: IView, data: SimpleData)
  c.getDataForPart(part: string): SimpleData # may create later a Part enum and move it as generic parameter. (in concept declaration)
  c.doSaveState()

