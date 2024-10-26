class_name UITask
extends HBoxContainer

@onready var check_box: CheckBox = %CheckBox
@onready var label: Label = %Label

var task: TaskData


func init(_task: TaskData) -> void:
	task = _task
	label.text = _task.display_name
	tooltip_text = _task.description
	check_box.button_pressed = _task.is_completed

	task.completed.connect(_on_task_completed)


func _on_task_completed(task: TaskData) -> void:
	check_box.button_pressed = true
