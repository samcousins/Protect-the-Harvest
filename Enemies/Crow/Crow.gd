extends CharacterBody3D

var speed := 3.0

var can_attack := true

var fireball_sc = preload("res://Enemies/Crow/Fireball/Fireball.tscn")

var hp := 1

var is_crow

@onready var target = get_parent().get_node("EnvironmentParent/Player")

@onready var beak = $Node2/root/head2/beak

var death_sound_sc = preload("res://Enemies/DeathSound.tscn")
var blood_sc = preload("res://Enemies/Blood.tscn")
var crow_death = preload("res://Enemies/Crow/crowhit.wav")


func _ready():
	$AnimationPlayer.play("flying")


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
	
	var fb = fireball_sc.instantiate()
	
	fb.transform = beak.global_transform
	
	var target_pos = target.global_translation

	fb.direction = beak.global_translation.direction_to(target_pos)
	
	get_parent().add_child(fb)
	
	$Shoot.play()
	
	$AttackCooldown.start()


func _on_AttackCooldown_timeout():
	can_attack = true


func take_damage(dmg):
	hp -= dmg
	if hp == 0:
		die()


func die():
	spawn_death_noise()
	spawn_blood()
	queue_free()


func spawn_blood():
	var blood = blood_sc.instantiate()
	blood.global_transform = global_transform
	get_tree().root.add_child(blood)
	queue_free()


func spawn_death_noise():
	var ds = death_sound_sc.instantiate()
	ds.global_transform = global_transform
	ds.sound = crow_death
	get_tree().root.add_child(ds)
