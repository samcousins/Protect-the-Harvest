extends CPUParticles3D

func _ready():
	emitting = true
	$Timer.start(lifetime)

func _on_Timer_timeout():
	queue_free()
