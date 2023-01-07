extends Spatial

var num_objectives := 0

onready var game_over_ui = $GameOver
onready var score_text = $GameOver/VBoxContainer/Score

var is_game_over := false
signal player_exited
signal game_over

var score := 0.0

func _ready():
	game_over_ui.visible = false
	
	var objectives = get_tree().get_nodes_in_group("objectives")
	num_objectives = objectives.size()
	
	for obj in objectives:
		obj.connect("obj_destroyed", self, "_on_obj_destroyed")

func _on_obj_destroyed():
	num_objectives -= 1
	if num_objectives <= 0:
		game_over()

func game_over():
	emit_signal("game_over")
	score_text.text = "Score: " + str(stepify(score, 0.01))
	game_over_ui.visible = true

func _process(delta):
	if not is_game_over:
		score += delta
	
	if Input.is_action_just_pressed("quit"):
		emit_signal("player_exited")
