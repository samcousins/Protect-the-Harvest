extends Spatial

func _on_Destruction_finished():
	queue_free()
