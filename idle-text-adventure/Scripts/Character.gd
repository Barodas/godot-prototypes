class_name Character

var character_id: String
var name: String
var level: int
var experience: int

var max_health: int
var health: int

var accuracy: int
var attack_damage: int
var attack_speed: float
var attack_timer: float

var activity: String
var location: String

var next_action: String
var travel_location: String
var travel_timer: float

var inventory = []

var weapon_slot: ItemWeapon

static func create(character_id: String, name: String, level: int, experience: int, max_health: int, health: int, accuracy: int, attack_damage: int, attack_speed:float):
	var character = Character.new()
	character.character_id = character_id
	character.name = name
	character.level = level
	character.experience = experience
	character.max_health = max_health
	character.health = health
	character.accuracy = accuracy
	character.attack_damage = attack_damage
	character.attack_speed = attack_speed
	return character

func update(delta: float):
	attack_timer += delta
	#Signals.character_changed.emit(self)
