extends Panel

@export var character_id: String

@onready var name_label: Label = $NamePanel/Name
@onready var stats_label: Label = $StatsPanel/VBoxContainer/Stats
@onready var log_panel: VBoxContainer = $LogPanel/ScrollContainer/LogContents
@onready var inventory_panel: VBoxContainer = $InventoryPanel/ScrollContainer/InventoryContents

# Equipment
@onready var weapon_slot: Label = $EquipmentPanel/VBoxContainer/WeaponSlot/HBoxContainer/ItemName
@onready var weapon_unequip: Button = $EquipmentPanel/VBoxContainer/WeaponSlot/HBoxContainer/UnequipButton

# Actions
@onready var action_label: Label = $ActionsPanel/VBoxContainer/ActionLabel
@onready var rest_button: Button = $ActionsPanel/VBoxContainer/RestButton
@onready var fight_button: Button = $ActionsPanel/VBoxContainer/FightButton
@onready var gather_button: Button = $ActionsPanel/VBoxContainer/GatherButton
@onready var guild_hall_button: Button = $ActionsPanel/VBoxContainer/GuildHallButton
@onready var meadows_button: Button = $ActionsPanel/VBoxContainer/MeadowsButton

func _ready():
	Signals.log_changed.connect(_on_log_changed)
	Signals.character_changed.connect(_on_character_changed)
	
	# Equipment
	weapon_unequip.pressed.connect(_on_weapon_unequip_pressed)
	
	# Actions
	rest_button.pressed.connect(_on_rest_pressed)
	fight_button.pressed.connect(_on_fight_pressed)
	gather_button.pressed.connect(_on_gather_pressed)
	guild_hall_button.pressed.connect(_on_guild_hall_pressed)
	meadows_button.pressed.connect(_on_meadows_pressed)

# TODO: It would probably be better to update UI by directly getting data from manager when view is open
# Likely better to do this once per second rather than on every change
func _on_character_changed(character):
	print("Character1 Updated")
	if character.character_id == character_id:
		name_label.text = character.name
		var stats_text = "Level: %s \nExp: %s / %s" % [character.level, character.experience, Constants.EXPERIENCE_PER_LEVEL[character.level - 1]]
		stats_label.text = stats_text
		action_label.text = character.activity
		
		# Equipment
		if character.weapon_slot:
			weapon_slot.text = character.weapon_slot.name
			weapon_unequip.visible = true
		else:
			weapon_slot.text = "none"
			weapon_unequip.visible = false
		
		# Inventory
		for item_node in inventory_panel.get_children():
			item_node.queue_free()
		var scene = load("res://InventoryItem.tscn") # TODO: Move this to ready()
		for iter in character.inventory.size():
			var instance = scene.instantiate()
			var target = "none"
			if character.location == "guild":
				target = "storage"
			instance.init(character_id, iter, character.inventory[iter], target)
			inventory_panel.add_child(instance)

func _on_log_changed(log_entry):
	if log_entry.has_tag(character_id):
		var log_label = Label.new()
		log_label.text = log_entry.message
		log_panel.add_child(log_label)

func unequip_item(equip_slot: String):
	Signals.unequip_item.emit(character_id, equip_slot)

func _on_weapon_unequip_pressed():
	unequip_item("weapon")

func change_action(action: String):
	Signals.change_character_action.emit(character_id, action)

func _on_rest_pressed():
	change_action("rest")
func _on_fight_pressed():
	change_action("fight")
func _on_gather_pressed():
	change_action("gather")
func _on_guild_hall_pressed():
	change_action("guild")
func _on_meadows_pressed():
	change_action("meadows")
