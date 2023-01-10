extends Spatial

var bullet_sc = preload("res://Weapons/Bullet/Bullet.tscn")

var bullets_in_shell := 20
var shell_spread := .3
var shell_count := 0

var can_shoot := true

var sped_up := false

onready var cooldown : Timer = $Cooldown
var cooldown_time := 0.5
onready var anim : AnimationPlayer = $AnimationPlayer

onready var speed_up_timer : Timer = $SpeedUpTimer
onready var speed_up_anim = $ShotgunCroc/SpeedUpAnim
onready var shells_count_ui = $ShotgunCroc/ShellsCount


func _ready():
	shells_count_ui.visible = false
	speed_up_anim.visible = false
	cooldown.wait_time = cooldown_time


func shoot():
	if not can_shoot:
		return
	
	can_shoot = false
	cooldown.start()
	
	if shell_count > 0:
		use_shell()
	else:
		use_bullet()
	
	anim.play("Cooldown")
	$Shoot.play()


func use_bullet():
	spawn_projectile(0)


func spawn_projectile(spread):
	randomize()
	var bullet = bullet_sc.instance()
	bullet.transform = $Barrel.global_transform
	bullet.rotation.x += rand_range(-(spread*0.25), spread*0.25)
	bullet.rotation.y += rand_range(-spread, spread)
	bullet.velocity = bullet.transform.basis.z * bullet.muzzle_velocity
	get_tree().root.add_child(bullet)


func _on_Cooldown_timeout():
	can_shoot = true


func power_up(power_name, power_time):
	if power_name == "speed_up":
		speed_up(power_time)
	if power_name == "shells":
		load_shells(power_time)


func speed_up(power_time):
	speed_up_anim.visible = true
	if not sped_up:
		anim.playback_speed = 2
		cooldown.wait_time = cooldown_time/2
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
	shell_count -= 1
	shells_count_ui.text = str(shell_count)
	if shell_count == 0:
		shells_count_ui.visible = false


func speed_power_down():
	speed_up_anim.visible = false
	anim.playback_speed = 1
	cooldown.wait_time = cooldown_time
	sped_up = false


func _on_SpeedUpTimer_timeout():
	speed_power_down()
