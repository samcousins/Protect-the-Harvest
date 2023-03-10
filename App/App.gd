extends Node

var main_menu_sc = preload("res://MainMenu/MainMenu.tscn")
var main_menu

var game_sc = preload("res://Game/Game.tscn")
var game

var play_music := true

var highscore := 0.0

var unlock_fps := false

var quit_cooldown
var can_quit := true

func _ready():
	add_main_menu()

func _process(_delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func add_main_menu():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if is_instance_valid(main_menu):
		main_menu.queue_free()
	
	main_menu = null
	main_menu = main_menu_sc.instance()
	
	main_menu.connect("start_game", self, "_on_start_game")
	main_menu.connect("music_toggled", self, "_on_music_toggled")
	main_menu.connect("fps_toggled", self, "_on_fps_toggled")
	
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
	
	game = game_sc.instance()
	
	game.play_music = play_music
	
	game.connect("player_exited", self, "_on_player_exited")
	game.connect("game_over", self, "_on_game_over")
	
	add_child(game)

func _on_player_exited():
	return_to_menu()

func return_to_menu():
	game.queue_free()
	game = null
	add_main_menu()

func _on_game_over(score):
	print("Game over - app")
	if score > highscore:
		highscore = score

func _on_music_toggled(state):
	print("Play music: " + str(state))
	play_music = state

func _on_fps_toggled(state):
	unlock_fps = state
