extends Area

var power_up_time := 5.0

func _ready():
	$Anim.play("Hover")

func _on_body_shape_entered(_rid, body, _bsi, _lsi):
	if body.has_method("power_up"):
		body.power_up(power_up_time)
