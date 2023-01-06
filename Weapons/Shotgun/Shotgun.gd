extends MeshInstance

var bullet_sc = preload("res://Weapons/Bullet.tscn")

export var number_of_shells := 10
var spread := 1.5

func shoot():
	for n in number_of_shells:
		var bullet = bullet_sc.instance()
		
		bullet.global_translation = $Barrel.global_translation
		
		bullet.direction = get_global_transform().basis.z
		bullet.direction.z += rand_range(-spread, spread)
		bullet.direction.y += rand_range(-spread, spread)
		bullet.direction.x += rand_range(-spread, spread)
		
		get_tree().root.add_child(bullet)
