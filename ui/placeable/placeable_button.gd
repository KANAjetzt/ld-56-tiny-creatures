class_name UIPlaceableButton
extends HBoxContainer


signal placeable_selected(button: UIPlaceableButton, placeable: PlaceableGlobalData)

@onready var button: Button = %Button
@onready var label: Label = %Label
@onready var progress_bar: ProgressBar = %ProgressBar

var data: PlaceableGlobalData


func _ready() -> void:
	data.amount_current_changed.connect(_on_amount_current_changed)


func set_icon(icon: Texture) -> void:
	button.icon = icon


func set_label(text: String) -> void:
	label.text = text


func tween_progress_bar() -> void:
	var tween := create_tween()
	tween.tween_method(progress_bar.set_value_no_signal, 0.0, 1.0, data.resupply_time)


func _on_button_pressed() -> void:
	placeable_selected.emit(self, data)
	Global.currently_selected_placeable = data
	print("selected %s" % data.id)


# TODO: This can be done better, checking on all buttons if the placeable is the same as the one in the button is not ideal.
# TODO: Rethink the global signal and implement something less lazy?
func _on_amount_current_changed(placeable: PlaceableGlobalData) -> void:
	if placeable == data:
		set_label(str(placeable.amount_current))

		if not placeable.amount_current == placeable.amount_max:
			tween_progress_bar()
		else:
			progress_bar.set_value_no_signal(0.0)
