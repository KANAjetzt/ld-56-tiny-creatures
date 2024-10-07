extends Node2D


@onready var placeable_preview: UIPlaceablePreview = %PlaceablePreview


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("place"):
		place_placeable()


func _on_placeables_placeable_selected(data: PlaceableData) -> void:
	placeable_preview.set_preview(data.icon)


func place_placeable() -> void:
	if not Global.currently_selected_placeable:
		push_error("ERROR: No placeable selected!")
		return
	if not Global.currently_selected_placeable.scene_path:
		assert(false, "ERROR: No scene_path in placeable_data!")
		return
	if Global.currently_selected_placeable.current_amount == 0:
		push_error("ERROR: Placeable amount is 0!")

	var new_placeable: Node2D = load(Global.currently_selected_placeable.scene_path).instantiate()
	add_child(new_placeable)
	new_placeable.global_position = get_global_mouse_position()

	Global.currently_selected_placeable.current_amount -= 1

	Global.placeable_placed.emit(Global.currently_selected_placeable)
