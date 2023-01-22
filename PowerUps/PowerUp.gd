extends Area3D

@export var power_up_time : float
@export var power_up_name : String
@export var power_up_icon : Texture2D

var spent := false

func _ready():
	$Img.texture = power_up_icon
	$Anim.play("Hover")

func _on_body_shape_entered(_rid, body, _bsi, _lsi):
	if body.has_method("power_up") and not spent:
		spent = true
		body.power_up(power_up_name, power_up_time)
		queue_free()

func _on_Death_timeout():
	queue_free()
