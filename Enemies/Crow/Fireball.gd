extends Area

var direction
var speed := 5

var is_fireball := true
var exploded := false


func _process(delta):
	global_translation += direction * speed * delta


func _on_Lifespan_timeout():
	queue_free()


func _on_Fireball_body_shape_entered(_rid, body, _bsi, _lsi):
	if "is_crow" in body or "is_fireball" in body:
		return
	elif "is_bullet" in body and not exploded:
		exploded = true
		body.queue_free()
		queue_free()
	elif body.has_method("take_damage") and not exploded:
		exploded = true
		body.take_damage(1)
		queue_free()
