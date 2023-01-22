extends StaticBody3D

var max_hp := 5
var hp : int

var destruction_sound = preload("res://Objectives/Hay/HayDestroyed.tscn")

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
	
	var dest = destruction_sound.instantiate()
	dest.global_translation = global_translation
	owner.add_child(dest)
	
	queue_free()
