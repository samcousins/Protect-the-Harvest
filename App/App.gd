extends Node

var main_menu_sc = preload("res://MainMenu/MainMenu.tscn")
var main_menu

var game_sc = preload("res://Game/Game.tscn")
var game

var quit_cooldown
var can_quit := true

func _ready():
	add_main_menu()

func add_main_menu():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if is_instance_valid(main_menu):
		main_menu.queue_free()
	
	main_menu = main_menu_sc.instance()
	main_menu.connect("start_game", self, "_on_start_game")
	add_child(main_menu)

func _on_start_game():
	main_menu.queue_free()
	add_game()

func add_game():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if is_instance_valid(game):
		game.queue_free()
	
	game = game_sc.instance()
	game.connect("player_exited", self, "_on_player_exited")
	add_child(game)

func _on_player_exited():
	return_to_menu()

func return_to_menu():
	game.queue_free()
	add_main_menu()
