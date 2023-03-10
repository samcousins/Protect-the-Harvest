extends Node

signal start_game
signal music_toggled(state)
signal fps_toggled(state)

onready var main_menu = $Menu/MenuVBox
onready var settings = $Menu/SettingsVBox
onready var controls = $Menu/Controls
onready var about = $Menu/About

func _ready():
	main_menu.visible = true
	settings.visible = false
	controls.visible = false
	about.visible = false
	
	$Menu/SettingsVBox/Fullscreen.pressed = OS.window_fullscreen
	
	fade_up()

func fade_up():
	$Menu/BlackScreen.visible = true
	$FadeUp.interpolate_property(
		$Menu/BlackScreen,
		"color:a",
		$Menu/BlackScreen.color.a,
		0, 
		2.0,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT,
		0.0
	)
	$FadeUp.start()

func _on_Start_pressed():
	emit_signal("start_game")


func _on_Quit_pressed():
	get_tree().quit()


func update_highscore(score):
	$Menu/MenuVBox/Highscore.text = "HIGHSCORE: " + str(stepify(score, 0.01))


func _on_Settings_pressed():
	main_menu.visible = false
	settings.visible = true


func _on_Music_toggled(button_pressed):
	emit_signal("music_toggled", button_pressed)


func _on_SettingsBack_pressed():
	main_menu.visible = true
	settings.visible = false


func _on_Fullscreen_toggled(button_pressed):
	OS.window_fullscreen = button_pressed


func _on_Controls_pressed():
	settings.visible = false
	controls.visible = true


func _on_ControlsBack_pressed():
	settings.visible = true
	controls.visible = false

func set_default_music(state):
	$Menu/SettingsVBox/Music.pressed = state

func set_unlock_fps(state):
	$"Menu/SettingsVBox/Unlock FPS".pressed = state


func _on_About_pressed():
	main_menu.visible = false
	about.visible = true


func _on_AboutBack_pressed():
	main_menu.visible = true
	about.visible = false

func _on_Unlock_FPS_toggled(button_pressed):
	emit_signal("fps_toggled", button_pressed)
	if button_pressed:
		Engine.set_target_fps(1000)
	else:
		Engine.set_target_fps(40)
