extends TextureProgress

var bar_green = preload("res://Objectives/Hay/GreenBar.png")
var bar_yellow = preload("res://Objectives/Hay/YellowBar.png")
var bar_red = preload("res://Objectives/Hay/RedBar.png")

func set_bounds(max_hp):
	min_value = 0
	max_value = max_hp
	value = max_hp

func update_bar(val, max_val):
	texture_progress = bar_green
	
	if val < (0.75 * max_val):
		texture_progress = bar_yellow
		
	if val < (0.45 * max_val):
		texture_progress = bar_red
		
	value = val
