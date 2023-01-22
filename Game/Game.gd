extends Node3D

signal player_exited
signal game_over(score)

@onready var game_over_ui = $GameOver
@onready var score_text = $GameOver/VBoxContainer/Score

var is_game_over := false

var num_objectives := 0

var score := 0.0

var play_music = true


func _ready():
	$EnvironmentParent/Player.player_died.connect(_on_player_died)
	
	game_over_ui.visible = false
	
	var objectives = get_tree().get_nodes_in_group("objectives")
	num_objectives = objectives.size()
	
	for obj in objectives:
		obj.obj_destroyed.connect(_on_obj_destroyed)
	
	if play_music:
		$Music.play()


func _process(delta):
	if not is_game_over:
		score += delta
	
	if Input.is_action_just_pressed("quit"):
		print("Pressed quit")
		emit_signal("player_exited")


func _on_obj_destroyed():
	num_objectives -= 1
	if num_objectives <= 0:
		call_game_over()


func _on_player_died():
	call_game_over()


func call_game_over():
	emit_signal("game_over", score)
	score_text.text = "Score: " + str(snapped(score, 0.01))
	game_over_ui.visible = true
	
	$Music.stop()
	$gameOver.play()
	
	get_tree().paused = true
