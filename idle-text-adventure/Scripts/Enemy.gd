class_name Enemy

# Instance of an EnemyTemplate

var template: EnemyTemplate

var health: int = 1
var armour: int = 0
var avoidance: int = 0

var accuracy: int = 1
var attack_damage: int = 1
var attack_speed: float = 2.0
var attack_timer: float = 0.0

func is_alive():
	return health > 0
