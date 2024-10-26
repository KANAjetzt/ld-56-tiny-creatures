class_name TasksData
extends Resource


@export var pollen_collect: Array[TaskData]
@export var habitat_deliver: Array[TaskData]
@export var habitat_find: Array[TaskData]


func get_all_tasks() -> Array[TaskData]:
	var tasks: Array[TaskData] = []
	tasks.append_array(pollen_collect)
	tasks.append_array(habitat_deliver)
	tasks.append_array(habitat_find)
	return tasks
