extends Node

signal start_game

func _on_Start_pressed():
	emit_signal("start_game")

func _on_Quit_pressed():
	get_tree().quit()

func update_highscore(score):
	$Menu/MenuVBox/Highscore.text = "HIGHSCORE: " + str(stepify(score, 0.01))
