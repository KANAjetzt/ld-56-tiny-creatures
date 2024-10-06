class_name BeeComponent
extends Node2D


@export var data: CreatureData
@export var movement: MovementComponent
@export var attractee: AttracteeComponent
@export var search_scale := 10
@export var search_distance_min := 100


func _ready() -> void:
	search()

	attractee.inside_attractor_area.connect(_on_inside_attractor_area)
	movement.target_reached.connect(_on_target_reached)


## Search the next attractor
func search() -> void:
	var random_direction := Vector2(randf() * 2.0 - 1.0, randf() * 2.0 - 1.0)
	var random_distance := movement.min_distance_to_target + search_distance_min + randf() * search_scale
	var new_target := movement.parent.global_position + random_direction * random_distance

	movement.target = new_target


## Travel to a set location
func travel(target: Vector2) -> void:
	movement.target = target


func _on_target_reached() -> void:
	if data.current_local_data == null:
		search()
	elif data.current_local_data:
		# Wait until the action at the local is done
		await get_tree().create_timer(data.current_local_data.wait_time).timeout
		# If at habitat start searching for plants
		if data.current_local_data.is_habitat:
			# Reset current_local_data after local was visited
			data.current_local_data = null
			search()
		# If not at habitat we are at a plant so travel home
		else:
			# Free the occupied space
			data.current_local_position.clear()
			# Start traveling to habitat
			data.current_local_data = data.current_habitat.data
			travel(data.current_habitat_position.global_position)


func _on_inside_attractor_area(area: AttractorArea) -> void:
	# Check if searching for habitat
	if data.current_habitat == null:
		# Check if valid habitat
		if area.ref.habitat.data in data.habitats:
			# Occupy position if available
			if not area.ref.creature_positions.all_occupied:
				data.current_habitat_position = area.ref.creature_positions.occupy_position()
				data.current_habitat = area.ref.habitat
				data.current_local_data = area.ref.habitat.data
				travel(data.current_habitat_position.global_position)

	# If habitat is found occupy plant
	if area.ref.plant:
		# Occupy position if available
		if not area.ref.creature_positions.all_occupied:
			var occupied_position := area.ref.creature_positions.occupy_position()
			data.current_local_position = occupied_position
			data.current_local_data = area.ref.plant.data
			travel(occupied_position.global_position)
