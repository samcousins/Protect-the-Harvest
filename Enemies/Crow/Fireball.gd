extends Area

var direction
var speed := 50.0

var is_fireball := true

func _process(delta):
	global_translation += direction * speed * delta


func _on_Lifespan_timeout():
	queue_free()


func _on_Fireball_body_shape_entered(_rid, body, _bsi, _lsi):
	if "is_fireball" in body:
		queue_free()
	elif "is_bullet" in body:
		body.queue_free()
		queue_free()
	elif body.has_method("take_damage"):
		body.take_damage(1)
