extends Control

@onready var summary_screen: CanvasItem = $SummaryScreen
@onready var guild_hall_screen: CanvasItem = $GuildHallScreen
@onready var maps_screen: CanvasItem = $MapSummaryScreen
@onready var storage_screen: CanvasItem = $StorageScreen
@onready var crafting_screen: CanvasItem = $CraftingScreen

@onready var character1_screen: CanvasItem = $Character1Screen
@onready var map_screen: CanvasItem = $MapScreen

@onready var screens = {
	"summary": summary_screen,
	"guild": guild_hall_screen,
	"maps": maps_screen,
	"storage": storage_screen,
	"crafting": crafting_screen,
	"character1": character1_screen,
	"map": map_screen}

var active_screen = "summary"
var prev_screen = "summary"

func _ready():
	Signals.change_screen.connect(change_screen)
	
	# Initialise screens to correct state
	toggle_screen("summary", true)
	toggle_screen("guild", false)
	toggle_screen("maps", false)
	toggle_screen("storage", false)
	toggle_screen("crafting", false)
	toggle_screen("character1", false)
	toggle_screen("map", false)

func _process(delta):
	pass

func _input(event):
	# print(event.as_text()) # Useful for checking mouse position and inputs
	if Input.is_action_just_pressed("return"):
		change_screen(get_return_screen(active_screen))
	if Input.is_action_just_pressed("back"):
		change_screen(get_return_screen(active_screen))

func _unhandled_input(event):
	if not Engine.is_editor_hint():
		if Input.is_action_just_pressed("quit"):
			get_tree().quit()

func change_screen(name):
	if name != active_screen:
		prev_screen = active_screen
		active_screen = name
		toggle_screen(prev_screen, false)
		toggle_screen(active_screen, true)

func return_screen():
	change_screen(get_return_screen(active_screen))

func back_screen():
	change_screen(get_back_screen())

func toggle_screen(name, state):
	var screen = screens[name]
	screen.visible = state

func get_return_screen(name):
	if name == "storage" || name == "crafting":
		return "guild"
	if name == "map":
		return "maps"
	return "summary"

func get_back_screen():
	# TODO: Track multiple screen navigations
	return prev_screen
