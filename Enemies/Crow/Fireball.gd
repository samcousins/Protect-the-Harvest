extends Area

var direction
var speed := 5

var is_fireball := true


func _process(delta):
	global_translation += direction * speed * delta


func _on_Lifespan_timeout():
	queue_free()


func _on_Fireball_body_shape_entered(_rid, body, _bsi, _lsi):
	print("boop")
	if "is_crow" in body or "is_fireball" in body:
		return
	elif "is_bullet" in body:
		body.queue_free()
		queue_free()
	elif body.has_method("take_damage"):
		print("Fireball detected target")
		body.take_damage(1)
