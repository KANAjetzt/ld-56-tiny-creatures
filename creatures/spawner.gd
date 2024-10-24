class_name SpawnerComponent
extends Node2D


var creature: CreatureData
var spawn_to: Node
var constructions_spawn_to: Node
var is_active := false:
	set = _set_is_active
var camera: Camera2D
var spawn_offset_min: int
var spawn_offset_max: int

func spawn() -> void:
	if not is_active:
		return

	await get_tree().create_timer(creature.spawn_time).timeout
	var camera_view_size := Utils.get_camera_view_size(camera)

	var multiplier_x := 1 if randf() > 0.5 else -1
	var random_x: int = (randi_range(spawn_offset_min, spawn_offset_max) + camera_view_size.x) * multiplier_x
	var multiplier_y := 1 if randf() > 0.5 else -1
	var random_y: int = (randi_range(spawn_offset_min, spawn_offset_max) + camera_view_size.y) * multiplier_y
	var random_position := Vector2(random_x, random_y)

	var new_creature: Node2D = load(creature.scene_path).instantiate()
	spawn_to.add_child(new_creature)
	new_creature.global_position = random_position

	var digging_component: DiggingComponent = new_creature.get("digging")
	if digging_component:
		digging_component.spawn_to = constructions_spawn_to

	if not Global.creature_count.has(creature.id):
		Global.creature_count[creature.id] = 1
	else:
		Global.creature_count[creature.id] += 1

	print("INFO: Spawned %s at %s" % [creature.id, random_position])

	if not creature.plants_per_spawn.is_empty():
		for plant_id in creature.plants_per_spawn:
			if not creature.plants.has(plant_id):
				assert(false, "Make sure to have the plant also in Plants - as a requirement.")
				return

			creature.plants[plant_id] += creature.plants_per_spawn[plant_id]

	for habitat in creature.habitats:
		if Global.current_habitats.has(habitat.id) and Global.current_habitats[habitat.id].space_free > 0:
			Global.current_habitats[habitat.id].remove()
			break

	Global.check_creature_criteria()
	spawn()


func _set_is_active(new_value) -> void:
	var previous_value := is_active
	is_active = new_value

	if previous_value == false and new_value == true:
		spawn()
