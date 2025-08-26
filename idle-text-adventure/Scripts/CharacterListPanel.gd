extends MarginContainer

const CHARACTER_INFO_TEMPLATE = "Level: %s \nClass: %s \nStatus: %s in %s"
func get_character_info_string(level, job, action, location):
	return CHARACTER_INFO_TEMPLATE % [level, job, action, location]

@onready var label_name = $VBoxContainer/Label_Name
@onready var label_info = $VBoxContainer/Label_Info

func _ready():
	Signals.character_changed.connect(_on_character_changed)


func _on_character_changed(character: Character):
	label_name.text = character.name
	# TODO: Create a specific signal for this panel? have a general call from character that sends multiple signals?
	label_info.text = get_character_info_string(character.level, "Warrior", "Fighting", "location")
