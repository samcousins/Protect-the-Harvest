extends PathFollow

var badger_sc = preload("res://Enemies/Badger/Badger.tscn")

onready var timer = $SpawnTimer

var game

func _ready():
	timer.start()
	offset += rand_range(0.0, 100.0)


func _process(delta):
	offset += delta * 10


func _on_SpawnTimer_timeout():
	print(name + " spawning enemy")
	var badger = badger_sc.instance()
	badger.global_translation = global_translation
	badger.scale *= 0.5
	game.add_child(badger)
	
	timer.wait_time = rand_range(2.0, 5.0)
	timer.start()
