extends Node


func create_timer(wait_time: float) -> SceneTreeTimer:
	return get_tree().create_timer(wait_time)


func get_camera_view_size(camera: Camera2D) -> Vector2:
	var viewport_size = camera.get_viewport_rect().size
	var zoom = camera.zoom
	return Vector2(
		viewport_size.x * zoom.x,
		viewport_size.y * zoom.y
	)
