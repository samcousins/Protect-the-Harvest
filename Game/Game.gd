extends Spatial

var num_objectives := 0

signal player_exited

func _ready():
	var objectives = get_tree().get_nodes_in_group("objectives")
	num_objectives = objectives.size()
	
	for obj in objectives:
		obj.connect("obj_destroyed", self, "_on_obj_destroyed")

func _on_obj_destroyed():
	num_objectives -= 1
	if num_objectives <= 0:
		game_over()

func game_over():
	print("Game over man")

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		emit_signal("player_exited")
