# This script (and children) are time-independent, so we can still exit on game over etc
extends Spatial

export var player_path := NodePath()
onready var player = get_node(player_path)

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		emit_signal("player_exited")

func _on_game_over():
	global_translation = player.global_translation
	$GameOver.play()
