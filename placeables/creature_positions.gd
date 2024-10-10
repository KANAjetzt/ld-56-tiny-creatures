class_name CreaturePositionsComponent
extends Node2D


@export var habitat: HabitatComponent

var all_occupied := false:
	set = _set_all_occupied
var creature_positions: Array[CreaturePositionComponent]
var creature_positions_free: Array[CreaturePositionComponent]

@onready var available_positions: int = get_child_count():
	set = _set_available_positions


func _ready() -> void:
	creature_positions.assign(get_children())
	creature_positions_free = creature_positions

	if habitat:
		if not Global.current_habitats_free.has(habitat.data.id):
			Global.current_habitats_free[habitat.data.id] = []
		Global.current_habitats_free[habitat.data.id].push_back(habitat.data)


func occupy_position() -> CreaturePositionComponent:
	if all_occupied:
		return null

	# TODO: Can be optimized
	var creature_position: CreaturePositionComponent = creature_positions_free.pick_random()
	creature_positions_free.erase(creature_position)

	creature_position.is_occupied = true
	available_positions -= 1
	return creature_position


func free_position(creature_position: CreaturePositionComponent) -> void:
	creature_positions_free.push_back(creature_position)
	creature_position.is_occupied = false
	available_positions += 1


func _set_all_occupied(new_value) -> void:
	all_occupied = new_value

	if all_occupied and habitat:
		Global.current_habitats_free[habitat.data.id].erase(habitat.data)
		if Global.current_habitats_free[habitat.data.id].is_empty():
			Global.current_habitats_free.erase(habitat.data.id)
			Global.check_creature_criteria()


func _set_available_positions(new_value) -> void:
	available_positions = new_value

	if new_value == 0:
		all_occupied = true
	elif new_value > 0:
		all_occupied = false
	else:
		print("ERROR: Available positions is %s" % new_value)
