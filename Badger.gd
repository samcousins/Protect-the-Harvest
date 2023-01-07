extends KinematicBody

var hp := 1

func take_damage(dmg):
	print("Took damage")
	hp -= dmg
	if hp <= 0:
		die()

func die():
	queue_free()
