extends MeshInstance

var bullet_sc = preload("res://Weapons/Bullet.tscn")

export var number_of_shells := 5

func shoot():
	for n in number_of_shells:
		var bullet = bullet_sc.instance()
		
		bullet.global_translation = $Barrel.global_translation
		
		bullet.direction = get_global_transform().basis.z
		bullet.direction.x += rand_range(-2.0, 2.0)
		bullet.direction.y += rand_range(-2.0, 2.0)
		
		get_tree().root.add_child(bullet)
