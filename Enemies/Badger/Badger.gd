extends CharacterBody3D

@onready var agent : NavigationAgent3D = $NavigationAgent3D
@onready var anim_player = $AnimationPlayer
@onready var audio = $Audio
@onready var attacking_sound = preload("res://Enemies/Badger/attack.wav")
@onready var walking_sound = preload("res://Enemies/Badger/grunting.wav")

var speed := 100

var gravity = -60

var can_attack := true

var hp := 1

var current_target

var death_sound_sc = preload("res://Enemies/DeathSound.tscn")

var blood_sc = preload("res://Enemies/Blood.tscn")

var badger_death = preload("res://Enemies/Badger/badgerDeath.wav")

var speed_power_up_sc = preload("res://PowerUps/SpeedUpPowerup/SpeedUpPowerUp.tscn")

var speed_power_up_chance := 0.1

var shells_power_up_sc = preload("res://PowerUps/ShellsPowerUp/ShellsPowerUp.tscn")

var shell_power_up_chance := 0.2


func _ready():
	randomize()
	find_new_target()
	anim_player.play("Walking")


func take_damage(dmg):
	print(name + " took damage")
	hp -= dmg
	if hp == 0:
		die()


func _physics_process(delta):
	if not current_target or not is_instance_valid(current_target):
		find_new_target()
		return
	
	look_at(Vector3(current_target.global_position.x, global_position.y, current_target.global_position.z), Vector3.UP)
	
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
	
	var dest = agent.get_next_path_position()
	
	velocity = global_position.direction_to(dest)
	
	velocity.y += gravity * delta
	
	set_velocity(velocity * speed * delta)
	move_and_slide()
	#velocity = velocity


func die():
	spawn_death_noise()
	spawn_blood()
	drop_power_up()
	queue_free()


func spawn_blood():
	var blood = blood_sc.instantiate()
	blood.global_transform = global_transform
	get_tree().root.add_child(blood)
	queue_free()


func spawn_death_noise():
	var ds = death_sound_sc.instantiate()
	ds.global_transform = global_transform
	ds.sound = badger_death
	get_tree().root.add_child(ds)


func drop_power_up():
	var roll = randf()
	if roll > 0.0 and roll <= speed_power_up_chance:
		var speed_power_up = speed_power_up_sc.instantiate()
		speed_power_up.global_transform = global_transform
		get_parent().add_child(speed_power_up)
	
	elif roll > speed_power_up_chance and roll <= shell_power_up_chance:
		var shells_power_up = shells_power_up_sc.instantiate()
		shells_power_up.global_transform = global_transform
		get_parent().add_child(shells_power_up)
	
	else:
		pass


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
	
	if targets.is_empty():
		return
	
	var distance := INF
	
	for target in targets:
		var new_dist = global_position.distance_squared_to(target.global_position)
		
		if new_dist < distance:
			distance = new_dist
			current_target = target
	
	if current_target:
		agent.set_target_position(current_target.global_position)
