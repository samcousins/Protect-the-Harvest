extends PathFollow3D

@onready var timer = $SpawnTimer

var to_spawn : PackedScene

var game

var timer_min := 2.0

var timer_max := 5.0

var reverse_dir := false


func _ready():
	randomize()
	timer.start()
	progress += randf_range(0.0, 100.0)


func _process(delta):
	if reverse_dir:
		progress -= delta * 10
	else:
		progress += delta * 10


func _on_SpawnTimer_timeout():
	var spawn = to_spawn.instantiate()
	spawn.position = global_position
	game.add_child(spawn)
	
	randomize()
	timer.wait_time = randf_range(timer_min, timer_max)
	timer.start()
