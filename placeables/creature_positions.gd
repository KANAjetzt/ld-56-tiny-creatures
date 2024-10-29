class_name CreaturePositionsComponent
extends Node2D


@export var habitat: HabitatComponent
## Use this to set an amount of positions not present as a [CreaturePositionComponent].
## Can be used instead of placing multiple [CreaturePositionComponent] at the same position.
@export var underground_positions := 0

var all_occupied := false:
	set = _set_all_occupied
var creature_positions: Array[CreaturePositionComponent]
var creature_positions_free: Array[CreaturePositionComponent]

@onready var available_positions: int = get_child_count() + underground_positions:
	set = _set_available_positions


func _ready() -> void:
	creature_positions.assign(get_children())
	creature_positions_free = creature_positions

	if habitat:
		if not Global.current_habitats.has(habitat.data_global.id):
			Global.current_habitats[habitat.data_global.id] = HabitatSpaceData.new(available_positions)
		else:
			Global.current_habitats[habitat.data_global.id].add(available_positions)


func occupy_position() -> CreaturePositionComponent:
	if all_occupied:
		return null

	# TODO: Can be optimized
	var creature_position: CreaturePositionComponent = creature_positions_free.pick_random()

	if not creature_position.is_entrance:
		creature_position.is_occupied = true
		creature_positions_free.erase(creature_position)

	available_positions -= 1
	return creature_position


func free_position(creature_position: CreaturePositionComponent) -> void:
	creature_positions_free.push_back(creature_position)
	creature_position.is_occupied = false
	available_positions += 1


func _set_all_occupied(new_value) -> void:
	all_occupied = new_value


func _set_available_positions(new_value) -> void:
	available_positions = new_value

	if new_value == 0:
		all_occupied = true
	elif new_value > 0:
		all_occupied = false
	else:
		print("ERROR: Available positions is %s" % new_value)
