class_name UIPlaceables
extends PanelContainer


signal placeable_selected(data: PlaceableData)

@export var placeable_button_scene: PackedScene

@onready var grid_container: GridContainer = %GridContainer

var is_hovering := false


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("exit"):
		hide()
	if Input.is_action_just_pressed("place") and not is_hovering:
		hide()

	if Input.is_action_just_pressed("inventory") and visible:
		hide()
	elif Input.is_action_just_pressed("inventory") and not visible:
		position = get_global_mouse_position()
		show()


func _ready() -> void:
	hide()

	for placeable in Global.placeables:
		var new_button: UIPlaceableButton = placeable_button_scene.instantiate()
		new_button.data = placeable
		grid_container.add_child(new_button)
		new_button.set_icon(placeable.icon)
		new_button.set_label(str(placeable.amount_max))

		new_button.placeable_selected.connect(_on_placeable_selected)


func _on_mouse_entered() -> void:
	is_hovering = true


func _on_mouse_exited() -> void:
	is_hovering = false


func _on_placeable_selected(button: UIPlaceableButton, placeable: PlaceableData) -> void:
	placeable_selected.emit(placeable)
