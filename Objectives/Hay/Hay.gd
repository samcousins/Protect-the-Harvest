extends StaticBody

var hp := 2

func _ready():
	add_to_group("objectives")

func attacked(dmg):
	hp -= dmg
	if hp <= 0:
		die()

func die():
	queue_free()
