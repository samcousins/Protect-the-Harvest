extends Spatial

func _on_Death_finished():
	queue_free()
