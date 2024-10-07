class_name UIPlaceableButton
extends HBoxContainer


signal placeable_selected(button: UIPlaceableButton, placeable: PlaceableData)

@onready var button: Button = %Button
@onready var label: Label = %Label

var data: PlaceableData


func _ready() -> void:
	Global.placeable_placed.connect(_on_placeable_placed)


func set_icon(icon: Texture) -> void:
	button.icon = icon


func set_label(text: String) -> void:
	label.text = text


func _on_button_pressed() -> void:
	placeable_selected.emit(self, data)
	Global.currently_selected_placeable = data
	print("selected %s" % data.id)


# TODO: This can be done better, checking on all buttons if the placeable is the same as the one in the button is not ideal.
# TODO: Rethink the global signal and implement something less lazy?
func _on_placeable_placed(placeable: PlaceableData) -> void:
	if placeable == data:
		set_label(str(placeable.current_amount))
