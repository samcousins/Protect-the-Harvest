extends Spatial

var bullet_sc = preload("res://Weapons/Bullet/Bullet.tscn")

export var number_of_shells := 20
var spread := 1.0

var can_shoot := true
var powered_up := false

onready var cooldown : Timer = $Cooldown
var cooldown_time := 0.5
onready var anim : AnimationPlayer = $AnimationPlayer

onready var power_up_timer : Timer = $PowerUp

func _ready():
	cooldown.wait_time = cooldown_time

func shoot():
	if not can_shoot:
		return
	
	can_shoot = false
	cooldown.start()
	
	var bullet = bullet_sc.instance()
	bullet.global_translation = $Barrel.global_translation
	bullet.direction = -get_global_transform().basis.z
	get_tree().root.add_child(bullet)
	
	anim.play("Cooldown")
	$Shoot.play()


func _on_Cooldown_timeout():
	can_shoot = true

func power_up(power_time):
	if not powered_up:
		anim.playback_speed = 2
		cooldown.wait_time = cooldown_time/2
		power_up_timer.wait_time = power_time
		power_up_timer.start()
	else:
		power_up_timer.remaining_time = power_time

func _on_PowerUp_timeout():
	power_down()
	
func power_down():
	anim.playback_speed = 1
	cooldown.wait_time = cooldown_time
	powered_up = false


