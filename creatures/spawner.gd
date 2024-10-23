class_name SpawnerComponent
extends Node2D


var creature: CreatureData
var spawn_to: Node
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
	var random_x: int = (randf() + 1) * spawn_offset_max + camera_view_size.x + spawn_offset_min
	var random_y: int = (randf() + 1) * spawn_offset_max + camera_view_size.y + spawn_offset_min
	var random_position := Vector2(random_x, random_y)

	var new_creature: Node2D = load(creature.scene_path).instantiate()
	spawn_to.add_child(new_creature)
	new_creature.global_position = random_position
	if not Global.creature_count.has(creature.id):
		Global.creature_count[creature.id] = 1
	else:
		Global.creature_count[creature.id] += 1

	print("INFO: Spawned %s at %s" % [creature.id, random_position])

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
