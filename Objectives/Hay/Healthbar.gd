extends Sprite3D

@onready var bar = $SubViewport/HealthbarTex

func _ready():
	texture = $SubViewport.get_texture()

func update(curr_val, max_val):
	bar.update_bar(curr_val, max_val)

func set_bounds(max_hp):
	$SubViewport/HealthbarTex.set_bounds(max_hp)
