extends Node2D


@export var spawner_scene: PackedScene


@onready var placeable_preview: UIPlaceablePreview = %PlaceablePreview
@onready var ui_placeables: UIPlaceables = %UIPlaceables
@onready var plants: Node = %Plants
@onready var placeables: Node = %Placeables


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("place") and not ui_placeables.is_hovering:
		place_placeable()


func _on_placeables_placeable_selected(data: PlaceableData) -> void:
	placeable_preview.set_preview(data.icon)


func place_placeable() -> void:
	if not Global.currently_selected_placeable:
		print("INFO: No placeable selected.")
		return
	if not Global.currently_selected_placeable.scene_path:
		assert(false, "ERROR: No scene_path in placeable_data.")
		return
	if Global.currently_selected_placeable.current_amount == 0:
		print("INFO: Placeable amount is 0.")

		Global.currently_selected_placeable = null
		placeable_preview.remove_preview()
		return

	var new_placeable: Node2D = load(Global.currently_selected_placeable.scene_path).instantiate()
	if Global.currently_selected_placeable.is_plant:
		plants.add_child(new_placeable)
	else:
		placeables.add_child(new_placeable)
	new_placeable.global_position = get_global_mouse_position()

	Global.currently_selected_placeable.current_amount -= 1

	if Global.currently_selected_placeable.is_plant:
		if not Global.currently_placed_plants.has(Global.currently_selected_placeable):
			Global.currently_placed_plants[Global.currently_selected_placeable] = 1
		else:
			Global.currently_placed_plants[Global.currently_selected_placeable] += 1

	Global.check_creature_criteria()
