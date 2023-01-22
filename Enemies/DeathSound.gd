extends Node3D

@export var sound : AudioStreamWAV

func _ready():
	$Death.stream = sound
	$Death.play()

func _on_Death_finished():
	queue_free()
