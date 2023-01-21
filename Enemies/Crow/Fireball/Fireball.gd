extends Area

var direction
var speed := 5

var is_fireball := true
var exploded := false

var explosion_sc = preload("res://Enemies/Crow/Fireball/FireballExplosion.tscn")

func _process(delta):
	global_translation += direction * speed * delta


func _on_Lifespan_timeout():
	queue_free()


func spawn_explosion():
	var explosion = explosion_sc.instance()
	explosion.global_translation = global_translation
	get_parent().add_child(explosion)


func _on_Fireball_body_shape_entered(_rid, body, _bsi, _lsi):
	if "is_crow" in body or "is_fireball" in body:
		return
	elif "is_bullet" in body and not exploded:
		exploded = true
		body.queue_free()
		spawn_explosion()
		queue_free()
	elif body.has_method("take_damage") and not exploded:
		exploded = true
		body.take_damage(1)
		spawn_explosion()
		queue_free()



func _on_Fireball_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	spawn_explosion()
	queue_free()
