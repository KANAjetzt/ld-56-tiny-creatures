class_name HabitatSpaceData
extends Resource


var space: int = 0
var space_free: int = 0
var space_occupied: int = 0


func _init(_space: int, _space_free: int = _space, _space_occupied: int = 0) -> void:
	space = _space
	space_free = _space_free
	space_occupied = _space_occupied


func add(count: int) -> int:
	space += count
	space_free += count

	return space_free


func remove(count: int = 1) -> int:
	if space_free - count < 0:
		assert(false, "The count should not go below 0.")
		return -1

	space_free -= count
	space_occupied += count

	return space_free
