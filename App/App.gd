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
	
	main_menu.connect("start_game",Callable(self,"_on_start_game"))
	main_menu.connect("music_toggled",Callable(self,"_on_music_toggled"))
	main_menu.connect("fps_toggled",Callable(self,"_on_fps_toggled"))
	
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
	
	game.connect("player_exited",Callable(self,"_on_player_exited"))
	game.connect("game_over",Callable(self,"_on_game_over"))
	
	add_child(game)


func _on_player_exited():
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
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	save_game.store_line(JSON.new().stringify(save_dict))
	save_game.close()


func _load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return
	
	save_game.open("user://savegame.save", File.READ)
	var test_json_conv = JSON.new()
	test_json_conv.parse(save_game.get_line())
	var app_data = test_json_conv.get_data()
	if app_data:
		if app_data.has("Highscore"):
			print("Data has highscore")
			highscore = app_data["Highscore"]
		if app_data.has("FPS"):
			print("Data has unlock FPS")
			unlock_fps = app_data["FPS"]
		if app_data.has("Music"):
			print("Data has music")
			play_music = app_data["Music"]
		if app_data.has("Fullscreen"):
			print("Data has fullscreen")
			get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (app_data["Fullscreen"]) else Window.MODE_WINDOWED
