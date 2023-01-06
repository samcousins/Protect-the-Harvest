extends Sprite3D

var direction = Vector3.FORWARD
var speed := 10.0

func _ready():
	set_as_toplevel(true)

func _physics_process(delta):
	global_translation += direction * speed * delta

func _on_Death_timeout():
	queue_free()
