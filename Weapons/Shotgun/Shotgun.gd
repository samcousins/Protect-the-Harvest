extends MeshInstance

var bullet_sc = preload("res://Weapons/Bullet.tscn")

func shoot():
	var bullet = bullet_sc.instance()
	
	bullet.global_translation = $Barrel.global_translation
	
	bullet.direction = get_global_transform().basis.z
	
	get_tree().root.add_child(bullet)
