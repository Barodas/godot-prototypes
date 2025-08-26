extends Panel

@onready var character1_name: Label = $Character1/VBoxContainer/Name
@onready var character1_info: Label = $Character1/VBoxContainer/Info

func _ready():
	Signals.character_changed.connect(_on_character_changed)

# TODO: It would probably be better to update UI by directly getting data from manager when view is open
# Likely better to do this once per second rather than on every change
func _on_character_changed(character):
	if character.character_id == "character1":
		character1_name.text = character.name
		var info_text = "Adventurer \nLevel: %s \nActivity: %s \nLocation: %s" % [character.level, character.activity, character.location]
		character1_info.text = info_text
