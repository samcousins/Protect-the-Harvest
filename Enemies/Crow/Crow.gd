extends KinematicBody

var speed := 3.0

var can_attack := true

var fireball_sc = preload("res://Enemies/Crow/Fireball.tscn")

var hp := 1

var is_crow

onready var target = get_parent().get_node("EnvironmentParent/Player")

func _ready():
	$Anim.play("Hovering")

func _process(delta):
	var target_pos = Vector3(target.global_translation.x, global_translation.y, target.global_translation.z)
	
	look_at(target_pos, Vector3.UP)
	
	if global_translation.distance_squared_to(target_pos) > 25:
		var direction = global_translation.direction_to(target_pos)
		global_translation += direction * speed * delta
	elif can_attack:
		attack()

func attack():
	can_attack = false
	
	var fb = fireball_sc.instance()
	
	fb.transform = $Beak.global_transform
	
	var target_pos = target.global_translation

	fb.direction = $Beak.global_translation.direction_to(target_pos)
	
	get_parent().add_child(fb)
	
	$AttackCooldown.start()


func _on_AttackCooldown_timeout():
	can_attack = true

func take_damage(dmg):
	hp -= dmg
	if hp == 0:
		die()

func die():
	queue_free()
