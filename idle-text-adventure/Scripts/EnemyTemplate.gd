class_name EnemyTemplate

# Template for generating an instance of an Enemy

var name: String
var max_health: int = 1
var armour: int = 0
var avoidance: int = 0

var accuracy: int = 1
var attack_damage: int = 1
var attack_speed: float = 2.0

var experience: int = 0
var gold_min: int = 0
var gold_max: int = 0
# TODO: var loot: LootTable

static func create(name: String, max_health: int, armour: int, avoidance: int, accuracy: int, attack_damage: int, attack_speed: float, experience: int, gold_min: int, gold_max: int):
	var template = EnemyTemplate.new()
	template.name = name
	template.max_health = max_health
	template.armour = armour
	template.avoidance = avoidance
	template.accuracy = accuracy
	template.attack_damage = attack_damage
	template.attack_speed = attack_speed
	template.experience = experience
	template.gold_min = gold_min
	template.gold_max = gold_max
	return template

func instantiate():
	var instance = Enemy.new()
	instance.template = self
	instance.health = max_health
	instance.armour = armour
	instance.avoidance = avoidance
	instance.accuracy = accuracy
	instance.attack_damage = attack_damage
	return instance
