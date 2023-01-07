extends StaticBody

var hp := 2

signal obj_destroyed

func _ready():
	add_to_group("objectives")

func attacked(dmg):
	hp -= dmg
	if hp <= 0:
		die()

func die():
	emit_signal("obj_destroyed")
	queue_free()
