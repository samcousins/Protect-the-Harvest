extends KinematicBody

export var target_path := NodePath()
onready var target = get_node(target_path)

var speed := 3.0

var can_attack := true

var fireball_sc = preload("res://Enemies/Crow/Fireball.tscn")

func _ready():
	$Anim.play("Hovering")


func _process(delta):
	var target_pos = Vector3(target.global_translation.x, global_translation.y, target.global_translation.z)
	
	if global_translation.distance_squared_to(target_pos) > 25:
		var direction = global_translation.direction_to(target_pos)
		global_translation += direction * speed * delta
	elif can_attack:
		attack()

func attack():
	can_attack = false
	
	var fb = fireball_sc.instance()
	
	fb.global_translation = $Beak.global_translation
	
	var target_pos = target.global_translation
	
	fb.look_at(target_pos, Vector3.UP)

	fb.direction = $Beak.global_translation.direction_to(target_pos)
	
	owner.add_child(fb)
	
	$AttackCooldown.start()


func _on_AttackCooldown_timeout():
	can_attack = true
