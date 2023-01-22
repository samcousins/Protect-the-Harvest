extends Node3D

func _on_Destruction_finished():
	queue_free()
