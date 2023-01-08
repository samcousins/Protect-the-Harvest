extends PathFollow

var badger_sc = preload("res://Enemies/Badger/Badger.tscn")

onready var timer = $SpawnTimer

var game

var reverse_dir := false

func _ready():
	timer.start()
	offset += rand_range(0.0, 100.0)


func _process(delta):
	if reverse_dir:
		offset -= delta * 10
	else:
		offset += delta * 10


func _on_SpawnTimer_timeout():
	var badger = badger_sc.instance()
	badger.global_translation = global_translation
	badger.scale *= 0.5
	game.add_child(badger)
	
	timer.wait_time = rand_range(2.0, 5.0)
	timer.start()
