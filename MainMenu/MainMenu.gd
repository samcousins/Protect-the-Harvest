extends Node

signal start_game

func _on_Start_pressed():
	emit_signal("start_game")

func _on_Quit_pressed():
	get_tree().quit()
