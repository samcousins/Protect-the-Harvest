extends Area

#var direction
var muzzle_velocity := 7
var direction

var velocity = Vector3.ZERO
export var g = Vector3.DOWN * 20

var is_bullet := true

var damage := 1


func _ready():
	scale = scale/4
	set_as_toplevel(true)


func _physics_process(delta):
	velocity += g * delta
	look_at(transform.origin + velocity.normalized(), Vector3.UP)
	transform.origin += velocity * delta


func _on_Death_timeout():
	queue_free()


func _on_collision(_rid, thing, _index, _lsi):
	if "is_bullet" in thing:
		return
	if thing.has_method("take_damage"):
		thing.take_damage(damage)
	queue_free()
