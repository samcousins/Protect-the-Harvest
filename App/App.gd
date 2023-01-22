extends Node

var main_menu_sc = preload("res://MainMenu/MainMenu.tscn")
var main_menu

var game_sc = preload("res://Game/Game.tscn")
var game

# Persistent things to save
var play_music := true
var highscore := 0.0
var unlock_fps := false


func _ready():
	get_tree().paused = false
	_load_game()
	add_main_menu()


func _process(_delta):
	if Input.is_action_just_pressed("fullscreen"):
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (!((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))) else Window.MODE_WINDOWED


func add_main_menu():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if is_instance_valid(main_menu):
		main_menu.queue_free()
	
	main_menu = null
	main_menu = main_menu_sc.instantiate()
	
	main_menu.start_game.connect(_on_start_game)
	main_menu.music_toggled.connect(_on_music_toggled)
	main_menu.fps_toggled.connect(_on_fps_toggled)
	
	main_menu.update_highscore(highscore)
	main_menu.set_default_music(play_music)
	main_menu.set_unlock_fps(unlock_fps)
	add_child(main_menu)


func _on_start_game():
	main_menu.queue_free()
	main_menu = null
	get_tree().paused = false
	add_game()


func add_game():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if is_instance_valid(game):
		game.queue_free()
	
	game = null
	
	game = game_sc.instantiate()
	
	game.play_music = play_music
	
	game.player_exited.connect(_on_player_exited)
	game.game_over.connect(_on_game_over)
	
	add_child(game)


func _on_player_exited():
	print("Player exited")
	return_to_menu()


func return_to_menu():
	_save_game()
	game.queue_free()
	game = null
	add_main_menu()


func _on_game_over(score):
	if score > highscore:
		highscore = score


func _on_music_toggled(state):
	play_music = state


func _on_fps_toggled(state):
	unlock_fps = state


func _save_game():
	var save_dict = {
		"Highscore" : snapped(highscore, 0.01),
		"FPS" : unlock_fps,
		"Music" : play_music,
		"Fullscreen" : ((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))
	}
	var file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	var json_string = JSON.stringify(save_dict)
	file.store_line(json_string)


func _load_game():
	if not FileAccess.file_exists("user://save_game.dat"):
		return
		
	var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
	
	var content = file.get_as_text()
	
	print("You need to implement loading of the data")
	print(content)
