extends Panel

@onready var storage_inventory_panel = $StorageContents/ScrollContainer/VBoxContainer
@onready var character_tab_panel = $CharacterSelection/HBoxContainer
@onready var character_inventory_panel = $CharacterInventory/ScrollContainer/VBoxContainer

var available_characters = []
var active_character_id = "none"

func _ready():
	Signals.storage_changed.connect(_on_storage_changed)
	Signals.character_changed.connect(_on_character_changed)

# TODO: move inventory refresh code into a function for use here and character screen
func _on_storage_changed(storage):
	for item_node in storage_inventory_panel.get_children():
		item_node.queue_free()
	var scene = load("res://InventoryItem.tscn") # TODO: Move this to ready()
	for iter in storage.size():
		var instance = scene.instantiate()
		var target = "none"
		if active_character_id != "none":
			target = active_character_id
		instance.init("storage", iter, storage[iter], target)
		storage_inventory_panel.add_child(instance)

func _on_character_changed(character):
	if character.location == "guild" && available_characters.find(character) < 0:
		available_characters.append(character) # TODO: should we store this differently?
	elif character.location != "guild" && available_characters.find(character) >= 0:
		available_characters.erase(character)
		if active_character_id == character.character_id:
			active_character_id = "none"
	for tab_node in character_tab_panel.get_children():
		tab_node.queue_free()
	for char in available_characters:
		var instance = Button.new()
		instance.text = char.name
		character_tab_panel.add_child(instance)
	if available_characters.size() > 0 && active_character_id == "none":
		active_character_id = available_characters[0].character_id
		
	if character.character_id == active_character_id:
		for item_node in character_inventory_panel.get_children():
			item_node.queue_free()
		var scene = load("res://InventoryItem.tscn") # TODO: Move this to ready()
		for iter in character.inventory.size():
			var instance = scene.instantiate()
			var target = "storage"
			instance.init(active_character_id, iter, character.inventory[iter], target)
			character_inventory_panel.add_child(instance)
