extends Spatial

var bullet_sc = preload("res://Weapons/Bullet/Bullet.tscn")

var bullets_in_shell := 20
var shell_spread := .3
var shell_count := 0

var sped_up := false

onready var anim : AnimationPlayer = $AnimationPlayer

onready var shoot_sound := $Shoot

onready var speed_up_timer : Timer = $SpeedUpTimer

onready var speed_up_anim = $Node2/root/body/SpeedUpAnim

onready var shells_count_ui = $Node2/root/body/ShellsCount

onready var barrel := $Node2/root/barrel/bottom_barrel_hole


func _ready():
	shells_count_ui.visible = false
	speed_up_anim.visible = false


func shoot():
	if anim.is_playing():
		return
	
	if shell_count > 0:
		use_shell()
	else:
		use_bullet()


func use_bullet():
	spawn_projectile(0)
	anim.play("shoot_normal")
	shoot_sound.play()


func spawn_projectile(spread):
	randomize()
	var bullet = bullet_sc.instance()
	bullet.transform = barrel.global_transform
	bullet.rotation.x += rand_range(-(spread*0.25), spread*0.25)
	bullet.rotation.y += rand_range(-spread, spread)
	bullet.velocity = bullet.transform.basis.z * bullet.muzzle_velocity
	get_tree().root.add_child(bullet)


func power_up(power_name, power_time):
	if power_name == "speed_up":
		speed_up(power_time)
	if power_name == "shells":
		load_shells(power_time)


func speed_up(power_time):
	speed_up_anim.visible = true
	
	if not sped_up:
		anim.playback_speed = 2
		speed_up_timer.wait_time = power_time
		speed_up_timer.start()
	
	else:
		speed_up_timer.remaining_time = power_time


# for shells, the power up time is the number of shells
func load_shells(power_time):
	shell_count += int(power_time)
	shells_count_ui.text = str(shell_count)
	shells_count_ui.visible = true


func use_shell():
	for n in bullets_in_shell:
		spawn_projectile(shell_spread)
		
	anim.play("shoot_shells")
	shoot_sound.play()
	
	shell_count -= 1
	shells_count_ui.text = str(shell_count)
	if shell_count == 0:
		shells_count_ui.visible = false


func speed_power_down():
	speed_up_anim.visible = false
	anim.playback_speed = 1
	sped_up = false


func _on_SpeedUpTimer_timeout():
	speed_power_down()
