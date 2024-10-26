extends Node


func create_timer(wait_time: float) -> SceneTreeTimer:
	return get_tree().create_timer(wait_time)


func get_camera_view_size(camera: Camera2D) -> Vector2:
	var viewport_size = camera.get_viewport_rect().size
	var zoom = camera.zoom
	return Vector2(
		viewport_size.x / zoom.x,
		viewport_size.y / zoom.y
	)


func get_global_creature_data(data: CreatureData) -> CreatureData:
	var global_creature_data: CreatureData = Global.creatures.filter(
		func get_bee(creature_data: CreatureData) -> bool:
				if creature_data.id == data.id:
					return true
				return false
	)[0]

	return global_creature_data


func free_children(parent: Node) -> void:
	for child in parent.get_children():
		child.queue_free()
