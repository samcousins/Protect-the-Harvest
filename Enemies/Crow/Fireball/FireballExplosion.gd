extends Spatial

func _ready():
	$Particles.emitting = true

func _on_Audio_finished():
	queue_free()
