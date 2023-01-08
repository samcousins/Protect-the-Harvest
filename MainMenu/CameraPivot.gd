extends Spatial


func _process(delta):
	global_rotation.y += 0.2 * delta
