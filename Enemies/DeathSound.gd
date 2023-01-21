extends Spatial

export var sound : AudioStreamSample

func _ready():
	$Death.stream = sound
	$Death.play()

func _on_Death_finished():
	queue_free()
