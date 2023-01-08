extends Sprite3D

onready var bar = $Viewport/HealthbarTex

func _ready():
	texture = $Viewport.get_texture()

func update(curr_val, max_val):
	bar.update_bar(curr_val, max_val)

func set_bounds(max_hp):
	$Viewport/HealthbarTex.set_bounds(max_hp)
