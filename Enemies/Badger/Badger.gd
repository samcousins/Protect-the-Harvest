extends KinematicBody

var hp := 1

var current_target

onready var agent : NavigationAgent = $NavigationAgent

var speed := 100

var gravity = -60

var velocity := Vector3()

var can_attack := true

onready var anim_player = $AnimationPlayer

onready var audio = $Audio
onready var attacking_sound = preload("res://Enemies/Badger/attack.wav")
onready var walking_sound = preload("res://Enemies/Badger/grunting.wav")

var death_sound_sc = preload("res://Enemies/Badger/BadgerDeathSound.tscn")

var power_up_sc = preload("res://PowerUp/PowerUp.tscn")
var power_up_chance := 0.2

var blood_sc = preload("res://Enemies/Badger/Blood.tscn")

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
		if anim_player.current_animation != "Attacking":
			anim_player.play("Attacking")
		if audio.stream != attacking_sound:
			audio.stream = attacking_sound
			audio.play()
		return
	else:
		if anim_player.current_animation != "Walking":
			anim_player.play("Walking")
		if audio.stream != walking_sound:
			audio.stream = walking_sound
			audio.play()
	
	var dest = agent.get_next_location()
	
	velocity = global_translation.direction_to(dest)
	
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity * speed * delta)

func die():
	spawn_death_noise()
	spawn_blood()
	drop_power_up()
	queue_free()

func spawn_blood():
	var blood = blood_sc.instance()
	blood.global_transform = global_transform
	get_tree().root.add_child(blood)
	queue_free()

func spawn_death_noise():
	var ds = death_sound_sc.instance()
	ds.global_transform = global_transform
	get_tree().root.add_child(ds)

func drop_power_up():
	var roll = randf()
	if roll <= power_up_chance:
		var power_up = power_up_sc.instance()
		power_up.global_transform = global_transform
		get_parent().add_child(power_up)

func attack():
	if can_attack and is_instance_valid(current_target):
		current_target.attacked(1)
		can_attack = false
		$Cooldown.start()

func _on_Cooldown_timeout():
	can_attack = true

func find_new_target():
	current_target = null
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
