extends Spatial

var bullet_sc = preload("res://Weapons/Bullet/Bullet.tscn")

export var number_of_shells := 20
var spread := 1.0

var can_shoot := true

onready var cooldown = $Cooldown

func shoot():
	if not can_shoot:
		return
	
	can_shoot = false
	cooldown.start()
	
	#for n in number_of_shells:
	var bullet = bullet_sc.instance()
	
	bullet.global_translation = $Barrel.global_translation
	
	bullet.direction = -get_global_transform().basis.z
		#bullet.direction.z += rand_range(-spread, spread)
		#bullet.direction.y += rand_range(-spread, spread)
		#bullet.direction.x += rand_range(-spread, spread)
		
	get_tree().root.add_child(bullet)


func _on_Cooldown_timeout():
	can_shoot = true
