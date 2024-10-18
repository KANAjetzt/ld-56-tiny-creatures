class_name UIPlaceables
extends PanelContainer


signal placeable_selected(data: PlaceableData)

@export var placeable_button_scene: PackedScene

@onready var grid_container: GridContainer = %GridContainer


func _ready() -> void:
	for placeable in Global.placeables:
		var new_button: UIPlaceableButton = placeable_button_scene.instantiate()
		new_button.data = placeable
		grid_container.add_child(new_button)
		new_button.set_icon(placeable.icon)
		new_button.set_label(str(placeable.amount_max))

		new_button.placeable_selected.connect(_on_placeable_selected)


func _on_placeable_selected(button: UIPlaceableButton, placeable: PlaceableData) -> void:
	placeable_selected.emit(placeable)
