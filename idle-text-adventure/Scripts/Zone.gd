class_name Zone

# Zones contain resources, enemies, and connections to neighbouring zones
# Characters discover paths of other zones by spending time in zone (fighting/gathering)
# TODO: Could zones also have modifiers? (things like weather or time of day that modify enemy/resource type/rates)

var name: String
var enemy_template: EnemyTemplate
var spawn_time: float = 1.0
var enemy_count: int = 1

# Enemy spawning is handled through an array of timers that track the respawn time of each individual enemy
var spawn_timers = []
var enemies = []
# TODO: how to we track individual enemy instances in combat? uuid?

static func create(name: String, enemy_template: EnemyTemplate, spawn_time: float, enemy_count: int):
	var zone = Zone.new()
	zone.name = name
	zone.enemy_template = enemy_template
	zone.spawn_time = spawn_time
	zone.enemy_count = enemy_count
	for i in zone.enemy_count:
		zone.enemies.push_back(zone.enemy_template.instantiate())
	return zone


func update(delta: float):
	# Update spawn timers and respawn enemies
	var finished_timers = []
	var it: int = 0
	#print("Zone Update, spawn_timers: ", spawn_timers.size())
	for i in range(spawn_timers.size() - 1, 0, -1):
		spawn_timers[i] += delta
		if spawn_timers[i] > spawn_time:
			#print("Zone Update, respawning index: ", i)
			enemies.push_back(enemy_template.instantiate())
			spawn_timers.remove_at(i)
	
	# Iterate backwards and remove finished timers from spawn_timers
	for i in range(finished_timers.size(), 0, -1):
		print("Removing Spawn Timer at index: ", i)
		spawn_timers.pop_at(i)
	
	
