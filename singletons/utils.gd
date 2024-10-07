extends Node


func create_timer(wait_time: float) -> SceneTreeTimer:
	return get_tree().create_timer(wait_time)
