class_name TasksData
extends Resource


signal all_tasks_completed

@export var pollen_collect: Array[TaskData]
@export var habitat_deliver: Array[TaskData]
@export var habitat_find: Array[TaskData]

var task_count: int = 0
var tasks_completed: int = 0
var is_all_completed := false

var is_initialized := false


func init() -> void:
	for task in get_all_tasks():
		task.completed.connect(_on_task_completed)
		task_count += 1

	is_initialized = true


func get_all_tasks() -> Array[TaskData]:
	var tasks: Array[TaskData] = []
	tasks.append_array(pollen_collect)
	tasks.append_array(habitat_deliver)
	tasks.append_array(habitat_find)
	return tasks


func _on_task_completed(task: TaskData) -> void:
	tasks_completed += 1
	if task_count == tasks_completed:
		is_all_completed = true
		all_tasks_completed.emit()
