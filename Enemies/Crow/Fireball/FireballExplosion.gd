extends Node3D

func _ready():
	$GPUParticles3D.emitting = true

func _on_Audio_finished():
	queue_free()
