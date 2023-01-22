extends Node

signal start_game
signal music_toggled(state)
signal fps_toggled(state)

@onready var main_menu = $Menu/MenuVBox
@onready var settings = $Menu/SettingsVBox
@onready var controls = $Menu/Controls
@onready var about = $Menu/About
@onready var volume = $Menu/SettingsVBox/VolumeHBox/VolumeSlider
@onready var black_screen = $Menu/BlackScreen
@onready var fullscreen = $Menu/SettingsVBox/Fullscreen
@onready var highscore = $Menu/MenuVBox/Highscore
@onready var music = $Menu/SettingsVBox/Music
@onready var fps = $"Menu/SettingsVBox/Unlock FPS"

func _ready():
	reset_menus()
	fade_up()


func reset_menus():
	main_menu.visible = true
	settings.visible = false
	controls.visible = false
	about.visible = false
	fullscreen.button_pressed = ((get_window().mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == DisplayServer.WINDOW_MODE_FULLSCREEN))
	volume.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))


func fade_up():
	black_screen.visible = true
	create_tween().tween_property(black_screen, "modulate:a", 0, 1.0)


func _on_Start_pressed():
	emit_signal("start_game")


func _on_Quit_pressed():
	get_tree().quit()


func update_highscore(score):
	highscore.text = "HIGHSCORE: " + str(snapped(score, 0.01))


func _on_Settings_pressed():
	main_menu.visible = false
	settings.visible = true


func _on_Music_toggled(button_pressed):
	emit_signal("music_toggled", button_pressed)


func _on_SettingsBack_pressed():
	main_menu.visible = true
	settings.visible = false


func _on_Fullscreen_toggled(button_pressed):
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (button_pressed) else Window.MODE_WINDOWED


func _on_Controls_pressed():
	settings.visible = false
	controls.visible = true


func _on_ControlsBack_pressed():
	settings.visible = true
	controls.visible = false


func set_default_music(state):
	music.button_pressed = state


func set_unlock_fps(state):
	fps.button_pressed = state


func _on_About_pressed():
	main_menu.visible = false
	about.visible = true


func _on_AboutBack_pressed():
	main_menu.visible = true
	about.visible = false

func _on_Unlock_FPS_toggled(button_pressed):
	emit_signal("fps_toggled", button_pressed)
	if button_pressed:
		Engine.max_fps = 120
	else:
		Engine.max_fps = 40


func _on_VolumeSlider_drag_ended(_value_changed):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume.value)
