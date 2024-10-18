extends Node


signal hover_changed(is_hovering: bool)

@export var mouse_over_control: Control
@export var transition_control: Control
@export var hidden_control: Control
@export var transition_time := 0.3


var original_minimum_size: Vector2
var is_hovering := false:
	set = _set_is_hovering


func _ready() -> void:
	original_minimum_size = Vector2(transition_control.custom_minimum_size)


func _process(delta: float) -> void:
	if mouse_over_control.get_global_rect().has_point(mouse_over_control.get_global_mouse_position()):
		is_hovering = true
	else:
		is_hovering = false


func transition_in() -> void:
	var tween := create_tween()
	tween.tween_property(transition_control, "custom_minimum_size:y", original_minimum_size.y + hidden_control.size.y, transition_time)


func transition_out() -> void:
	var tween := create_tween()
	tween.tween_property(transition_control, "custom_minimum_size:y", original_minimum_size.y, transition_time)


func _set_is_hovering(new_value) -> void:
	var previous_value := is_hovering
	is_hovering = new_value

	if previous_value == false and new_value == true:
		print("mouse_entered")
		transition_in()
		hover_changed.emit(new_value)

	if previous_value == true and new_value == false:
		print("mouse_exited")
		transition_out()
		hover_changed.emit(new_value)
