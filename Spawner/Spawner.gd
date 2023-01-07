extends PathFollow

var badger_sc = preload("res://Enemies/Badger/Badger2.tscn")

onready var timer = $SpawnTimer

func _ready():
	timer.start()
	offset += rand_range(0.0, 100.0)


func _process(delta):
	offset += delta * 10


func _on_SpawnTimer_timeout():
	var badger = badger_sc.instance()
	badger.global_translation = global_translation
	badger.scale *= 0.5
	get_tree().root.add_child(badger)
	
	timer.wait_time = rand_range(1.0, 3.0)
	timer.start()
