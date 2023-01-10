extends Spatial

var bullet_sc = preload("res://Weapons/Bullet/Bullet.tscn")

export var number_of_shells := 20
var spread := 1.0

var can_shoot := true
var sped_up := false

onready var cooldown : Timer = $Cooldown
var cooldown_time := 0.5
onready var anim : AnimationPlayer = $AnimationPlayer

onready var speed_up_timer : Timer = $SpeedUpTimer
onready var speed_up_anim = $ShotgunCroc/SpeedUpAnim

func _ready():
	speed_up_anim.visible = false
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

func power_up(power_name, power_time):
	if power_name == "speed_up":
		speed_up(power_time)

func speed_up(power_time):
	speed_up_anim.visible = true
	if not sped_up:
		anim.playback_speed = 2
		cooldown.wait_time = cooldown_time/2
		speed_up_timer.wait_time = power_time
		speed_up_timer.start()
	else:
		speed_up_timer.remaining_time = power_time

func _on_PowerUp_timeout():
	power_down()
	
func power_down():
	speed_up_anim.visible = false
	anim.playback_speed = 1
	cooldown.wait_time = cooldown_time
	powered_up = false


