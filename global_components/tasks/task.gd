class_name TaskData
extends Resource


signal completed(task: TaskData)

@export var id := ""
@export var display_name := ""
@export var description := ""
@export var is_completed := false:
	set = _set_is_completed
## Add placeables that are unlocked if this task is completed
@export var unlocks_placeable: Array[PlaceableData] = []


func _set_is_completed(new_value) -> void:
	is_completed = new_value
	completed.emit(self)

	for unlock in unlocks_placeable:
		unlock.is_unlocked = true
