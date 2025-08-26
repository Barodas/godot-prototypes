extends HBoxContainer

const CHARACTER_STATS_TEMPLATE = "XP: %s/%s \nHealth: %s/%s \nMana: %s/%s \nStr: %s"
func get_character_stats_string(curXp, xpToLevel, curHp, maxHp, curMP, maxMp, str):
	return CHARACTER_STATS_TEMPLATE % [curXp, xpToLevel, curHp, maxHp, curMP, maxMp, str]

@onready var character_stats = $CharacterStats/Label_Info
@onready var character_log = $CharacterLog/Label_Info

func _ready():
	Signals.character_changed.connect(_on_character_changed)
	Signals.log_changed.connect(_on_log_changed)


func _on_character_changed(character: Character):
	character_stats.text = get_character_stats_string(character.experience, Constants.EXPERIENCE_PER_LEVEL[character.level - 1], character.health, character.max_health, "N/A", "N/A", "N/A")

func _on_log_changed(log):
	var text: String
	var log_limit = min(20, log.size())
	for i in range(1, log_limit, 1):
		text += log[-i].message
		text += "\n"
	character_log.text = text
