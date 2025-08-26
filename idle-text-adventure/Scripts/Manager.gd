extends Node

var log = []

var storage = []
var character: Character
var zone: Zone

# All logs are stored in array, when added a signal is fired so different log views can grab ones relevant to them
func add_log(message: String, tags):
	var debug_log = "MESSAGE: %s TAGS: %s" % [message, tags]
	print(debug_log)
	var new_entry = LogEntry.create(message, tags)
	log.push_back(new_entry)
	Signals.log_changed.emit(new_entry)

func _ready():
	randomize() # Initialise random number generator
	
	Signals.change_character_action.connect(_change_character_action)
	Signals.equip_item.connect(_equip_item)
	Signals.unequip_item.connect(_unequip_item)
	Signals.delete_item.connect(_delete_item_from_inventory)
	Signals.transfer_item.connect(_transfer_item)
	
	# Initialise Data	
	character = Character.create("character1","Baro", 1, 0, 10, 10, 1, 1, 1.5)
	character.activity = "resting"
	character.location = "guild"
	var weapon1 = ItemWeapon.create_weapon("weapon_stick", "Stick", "weapon", 2)
	character.inventory.append(weapon1)
	var weapon2 = ItemWeapon.create_weapon("weapon_stick2", "Heavy Stick", "weapon", 4)
	character.inventory.append(weapon2)
	
	var enemy_mouse = EnemyTemplate.create("Mouse", 3, 0, 0, 1, 1, 2.0, 1, 0, 0)
	zone = Zone.create("Grasslands", enemy_mouse, 5.0, 3)

func _process(delta):
	zone.update(delta)
	character.update(delta)
	
	if character.next_action != "none":
		if character.next_action == "rest":
			character.activity = "resting"
		if character.next_action == "fight" && character.location != "guild":
			character.activity = "fighting"
		if character.next_action == "gather" && character.location != "guild":
			character.activity = "gathering"
		if character.next_action == "guild" && character.location != "guild":
			character.activity = "travelling"
			character.travel_location = "guild"
			character.location = "on the road"
		if character.next_action == "meadows" && character.location != "meadows":
			character.activity = "travelling"
			character.travel_location = "meadows"
			character.location = "on the road"
		character.next_action = "none"
		Signals.character_changed.emit(character)
		Signals.storage_changed.emit(storage) # Needed to update transfer buttons in storage
	
	if character.activity == "travelling":
		character.travel_timer += delta
		if character.travel_timer > 1:
			character.travel_timer = 0
			character.location = character.travel_location
			character.activity = "resting"
			Signals.character_changed.emit(character)
			Signals.storage_changed.emit(storage) # Needed to update transfer buttons in storage
	
	if character.activity == "fighting":
		if character.attack_timer > character.attack_speed && zone.enemies.size() > 0:
			character.attack_timer = 0
			var damage = character.attack_damage
			if character.weapon_slot:
				damage += character.weapon_slot.damage
			zone.enemies[0].health -= damage
			add_log("%s hits %s for %s damage!" % [character.name, zone.enemies[0].template.name, damage], ["character1"])
			if !zone.enemies[0].is_alive():
				add_log("%s has died, %s gained %s exp" % [zone.enemies[0].template.name, character.name, zone.enemies[0].template.experience], ["character1"])
				character.experience += zone.enemies[0].template.experience
				Signals.character_changed.emit(character)
				zone.enemies.pop_front()
				zone.spawn_timers.push_back(0.0)
	
	if character.activity == "gathering":
		if character.attack_timer > character.attack_speed:
			character.attack_timer = 0
			if (randi() % 100) + 1 > 50:
				var gathered_item = Item.create("wood", "Wood", (randi() % 2) + 1)
				add_item(character.inventory, gathered_item)
				Signals.character_changed.emit(character)
				add_log("%s has gathered %s %s!" % [character.name, gathered_item.name, gathered_item.amount], ["character1"])
	
	# Check for level up
	if character.experience > Constants.EXPERIENCE_PER_LEVEL[character.level - 1]:
		character.level += 1
		character.experience = 0
		Signals.character_changed.emit(character)
		add_log("%s has reached level %s!" % [character.name, character.level], ["character1"])
	
	# TODO: need some kind of combat manager, each enemy need to know if theyve been engaged in order to fight back, enemies should be able to aggro to the character based on some aggression/call for help mechanic. Character needs to know who its fighting

func _change_character_action(character_id: String, action: String):
	# TODO: Add switch for character_id for now assuming character1
	character.next_action = action

# Character Equipment
func _equip_item(character_id: String, slot: int):
	if character_id == "character1":
		var item = character.inventory[slot]
		remove_slot(character.inventory, slot)
		_unequip_item(character_id, item.equip_slot)
		if item.equip_slot == "weapon":
			character.weapon_slot = item
		Signals.character_changed.emit(character)

func _unequip_item(character_id: String, equip_slot: String):
	if character_id == "character1" && character.weapon_slot:
		var item = character.weapon_slot
		character.weapon_slot = null
		add_item(character.inventory, item)
		Signals.character_changed.emit(character)

# Item Management
func _transfer_item(from_id: String, to_id: String, slot: int):
	var from = get_inventory(from_id)
	var to = get_inventory(to_id)
	add_item(to, from[slot])
	remove_slot(from, slot)
	add_log("Transferred item at slot %s in %s inventory to %s inventory" % [slot, from_id, to_id], [from_id, to_id])
	if from_id == "storage" || to_id == "storage":
		Signals.storage_changed.emit(storage)
	if from_id == "character1" || to_id == "character1":
		Signals.character_changed.emit(character)

func get_inventory(owner_id: String):
	if owner_id == "storage":
		return storage
	if owner_id == "character1":
		return character.inventory

func _delete_item_from_inventory(owner_id: String, slot: int):
	var inventory = get_inventory(owner_id)
	remove_slot(inventory, slot)
	if owner_id == "storage":
		Signals.storage_changed.emit(storage)
		add_log("Deleted item at slot %s in storage" % [slot], ["storage"])
	if owner_id == "character1":
		Signals.character_changed.emit(character)
		add_log("Deleted item at slot %s in %s's inventory" % [slot, character.name], ["character1"])

func add_item(inventory, item: Item):
	for slot in inventory:
		if slot.item_id == item.item_id:
			slot.amount += item.amount
			return
	
	inventory.append(item)

func remove_slot(inventory, slot: int):
	inventory.remove_at(slot)

func remove_item(inventory, item: Item):
	# TODO: This version would be used for things that remove a portion of a stack (crafting, quest turn-in)
	pass
