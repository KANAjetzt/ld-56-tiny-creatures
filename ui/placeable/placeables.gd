class_name UIPlaceables
extends PanelContainer


signal placeable_selected(data: PlaceableGlobalData)

@export var placeable_button_scene: PackedScene

@onready var grid_container: GridContainer = %GridContainer


func _ready() -> void:
	for placeable in Global.placeables:
		if not placeable.is_unlocked:
			continue

		add_placeable(placeable)


func add_placeable(placeable: PlaceableGlobalData) -> void:
	var new_button: UIPlaceableButton = placeable_button_scene.instantiate()
	new_button.data = placeable
	grid_container.add_child(new_button)
	new_button.set_icon(placeable.icon)
	new_button.set_label(str(placeable.amount_max))

	new_button.placeable_selected.connect(_on_placeable_selected)
	placeable.got_unlocked.connect(_on_placeable_got_unlocked)


func _on_placeable_selected(_button: UIPlaceableButton, placeable: PlaceableGlobalData) -> void:
	placeable_selected.emit(placeable)


func _on_placeable_got_unlocked(placeable: PlaceableGlobalData) -> void:
	add_placeable(placeable)
