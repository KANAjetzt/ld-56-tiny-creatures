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
func travel() -> void:
	if not data.current_habitat:
		print("ERROR: No habitat found!")

	movement.target = data.current_habitat.global_position


func _on_target_reached() -> void:
	if data.current_local == null:
		search()
	elif data.current_local:
		# Wait until the action at the local is done
		await get_tree().create_timer(data.current_local.wait_time).timeout
		# If @ habitat start searching for plants
		if data.current_local.is_habitat:
			data.current_local = null
			search()
		# If not at habitat we are @ a plant so travel home
		else:
			travel()



func _on_inside_attractor_area(area: AttractorArea) -> void:
	# Check if searching for habitat
	if data.current_habitat == null:
		# Check if valid habitat
		if area.ref.habitat.data in data.habitats:
			# Occupy position if available
			if not area.ref.creature_positions.all_occupied:
				area.ref.creature_positions.occupy_position()
				data.current_habitat = area.ref.habitat
				data.current_local = area.ref.habitat.data
				travel()
