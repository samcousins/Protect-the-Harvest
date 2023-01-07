extends KinematicBody

var hp := 1

var current_target

onready var agent : NavigationAgent = $NavigationAgent

var speed := 100

var gravity = -60

var velocity := Vector3()

func _ready():
	
	var targets := get_tree().get_nodes_in_group("objectives")
	
	var distance := INF
	
	for target in targets:
		var new_dist = global_translation.distance_squared_to(target.global_translation)
		if new_dist < distance:
			distance = new_dist
			current_target = target
	
	agent.set_target_location(current_target.global_translation)

func take_damage(dmg):
	print("Took damage")
	hp -= dmg
	if hp <= 0:
		die()

func _physics_process(delta):
	if agent.distance_to_target() < agent.target_desired_distance:
		return
	
	var dest = agent.get_next_location()
	
	velocity = global_translation.direction_to(dest)
	
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity * speed * delta)

func die():
	queue_free()
