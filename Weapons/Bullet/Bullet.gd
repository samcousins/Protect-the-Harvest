extends Area

var direction = Vector3.FORWARD
var speed := 5.0

var is_bullet := true

var damage := 1

func _ready():
	set_as_toplevel(true)

func _physics_process(delta):
	global_translation += direction * speed * delta

func _on_Death_timeout():
	queue_free()

func _on_collision(_rid, thing, _index, _lsi):
	if "is_bullet" in thing:
		return
	print("Hit something!")
	if thing.has_method("take_damage"):
		thing.take_damage(damage)
	queue_free()
