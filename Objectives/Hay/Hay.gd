extends StaticBody

var max_hp := 5
var hp : int

signal obj_destroyed

func _ready():
	hp = max_hp
	add_to_group("objectives")
	$Healthbar.set_bounds(max_hp)

func attacked(dmg):
	hp -= dmg
	$AnimationPlayer.play("Damaged")
	$Attacked.play()
	$Healthbar.update(hp, max_hp)
	if hp <= 0:
		die()

func die():
	emit_signal("obj_destroyed")
	queue_free()
