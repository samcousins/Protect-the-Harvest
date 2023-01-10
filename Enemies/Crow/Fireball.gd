extends KinematicBody

var direction
var speed := 50.0

func _ready():
	print(direction)

func _process(delta):
	global_translation += direction * speed * delta


func _on_Lifespan_timeout():
	queue_free()
