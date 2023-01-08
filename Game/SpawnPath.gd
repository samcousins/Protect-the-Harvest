extends Path

var enemy_spawner = preload("res://Spawner/Spawner.tscn")

export var game_path := NodePath()
onready var game = get_node(game_path)

func _ready():
	for child in get_children():
		if "game" in child: 
			child.game = game

func _on_SpawnTimer_timeout():
	print("Spawning another spawner")
	var spawner = enemy_spawner.instance()
	spawner.game = game
	add_child(spawner)
	
	$SpawnTimer.wait_time += 10
	$SpawnTimer.start()
