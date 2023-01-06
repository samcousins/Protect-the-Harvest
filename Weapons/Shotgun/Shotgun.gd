extends MeshInstance

var bullet_sc = preload("res://Weapons/Bullet.tscn")

func shoot():
	var bullet = bullet_sc.instance()
	
	bullet.global_translation = $Barrel.global_translation
	
	bullet.direction = get_global_transform().basis.z
	bullet.direction.x += rand_range(-1.0, 1.0)
	bullet.direction.y += rand_range(-1.0, 1.0)
	
	get_tree().root.add_child(bullet)
