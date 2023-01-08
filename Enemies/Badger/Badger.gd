extends KinematicBody

var hp := 1

var current_target

onready var agent : NavigationAgent = $NavigationAgent

var speed := 100

var gravity = -60

var velocity := Vector3()

var can_attack := true

onready var anim_player = $AnimationPlayer

func _ready():
	find_new_target()
	anim_player.play("Walking")

func take_damage(dmg):
	print("Took damage")
	hp -= dmg
	if hp <= 0:
		die()

func _physics_process(delta):
	if not current_target or not is_instance_valid(current_target):
		find_new_target()
		return
	
	look_at(Vector3(current_target.global_translation.x, global_translation.y, current_target.global_translation.z), Vector3.UP)
	
	if agent.distance_to_target() < agent.target_desired_distance:
		if can_attack:
			attack()
		return
	
	var dest = agent.get_next_location()
	
	velocity = global_translation.direction_to(dest)
	
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity * speed * delta)

func die():
	queue_free()

func attack():
	current_target.attacked(1)
	can_attack = false
	$Cooldown.start()

func _on_Cooldown_timeout():
	can_attack = true

func find_new_target():
	var targets := get_tree().get_nodes_in_group("objectives")
	
	if targets.size() == 0 or not targets:
		return
	
	var distance := INF
	
	for target in targets:
		var new_dist = global_translation.distance_squared_to(target.global_translation)
		if new_dist < distance:
			distance = new_dist
			current_target = target
	
	if current_target:
		agent.set_target_location(current_target.global_translation)
