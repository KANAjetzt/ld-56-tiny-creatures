class_name CreaturePositionsComponent
extends Node2D


var all_occupied := false
var creature_positions: Array[CreaturePositionComponent]

@onready var available_positions: int = get_child_count()


func _ready() -> void:
	creature_positions.assign(get_children())


func occupy_position() -> CreaturePositionComponent:
	if all_occupied:
		return null

	for creature_position in creature_positions:
		if not creature_position.is_occupied:
			creature_position.is_occupied = true
			available_positions -= 1
			return creature_position

	if available_positions == 0:
		all_occupied ==  true

	return null


func free_position(creature_position: CreaturePositionComponent) -> void:
	creature_position.is_occupied = false
	available_positions += 1
