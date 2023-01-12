extends Path

var enemy_spawner = preload("res://Spawner/Spawner.tscn")

export var to_spawn : PackedScene

export var game_path := NodePath()
onready var game = get_node(game_path)

export var player_path := NodePath()

export var time_till_next_spawner := 30.0
export var time_to_add := 10.0

export var spawn_time_min := 2.0
export var spawn_time_max := 5.0

var reverse_dir := true


func _ready():
	$SpawnTimer.wait_time = time_till_next_spawner
	add_spawner(false)


func _on_SpawnTimer_timeout():
	add_spawner(true)


func add_spawner(add_delay):
	var spawner = enemy_spawner.instance()
	
	spawner.to_spawn = to_spawn
	spawner.game = game
	spawner.reverse_dir = reverse_dir
	
	spawner.timer_min = spawn_time_min
	spawner.timer_max = spawn_time_max
	
	reverse_dir = !reverse_dir
		
	add_child(spawner)
	
	if add_delay:
		$SpawnTimer.wait_time += time_to_add
	$SpawnTimer.start()
