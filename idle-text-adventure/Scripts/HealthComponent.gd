class_name HealthComponent

var MAX_HEALTH : int = 1
var health : int

func _ready():
	health = MAX_HEALTH


func damage(attack: Attack):
	# TODO: Health component needs to pull defence info if applicable
	# TODO: Attack should use a function that takes the defence and calculates actual damage
	health -= attack.calculate_damage()
	
	if health <= 0:
		pass
		# TODO: Send an event to the parent player/enemy to handle death
