extends CharacterBody3D

signal player_died

@onready var camera = $Pivot/Camera3D
@onready var hp_ui = $HUD/Life

var gravity := -30
var max_speed := 8
var mouse_sensitivity := 0.004  # radians/pixel

var velocity = Vector3()

var play_music := true

var hp := 3

@onready var equipped_weapon = $Pivot/Gun

@onready var tween := $HUD/FadeIn/Tween
@onready var fade_in_screen := $HUD/FadeIn

func _ready():
	tween.interpolate_property(
		fade_in_screen,
		"modulate",
		Color(1, 1, 1, 1), Color(1, 1, 1, 0), 
		1.0, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN
	)
	tween.start()
	
	$Start.play()
	
	hp_ui.text = str(hp)


func get_input():
	var input_dir = Vector3()
	# desired move in camera direction
	if Input.is_action_pressed("move_forward"):
		input_dir += -global_transform.basis.z
	if Input.is_action_pressed("move_back"):
		input_dir += global_transform.basis.z
	if Input.is_action_pressed("strafe_left"):
		input_dir += -global_transform.basis.x
	if Input.is_action_pressed("strafe_right"):
		input_dir += global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)


func _process(_delta):
	if Input.is_action_just_pressed("shoot"):
		equipped_weapon.shoot()


func _physics_process(delta):
	velocity.y += gravity * delta
	var desired_velocity = get_input() * max_speed

	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	set_velocity(velocity)
	set_up_direction(Vector3.UP)
	set_floor_stop_on_slope_enabled(true)
	move_and_slide()
	velocity = velocity


func power_up(power_name, power_time):
	equipped_weapon.power_up(power_name, power_time)
	$PowerUp.play()


func take_damage(amount):
	hp -= amount
	hp_ui.text = str(hp)
	$Oof.play()
	if hp == 0:
		emit_signal("player_died")
