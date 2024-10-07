class_name SpawnerComponent
extends Node2D


var creature: CreatureData
var spawn_to: Node
var is_active := false:
	set = _set_is_active


func spawn() -> void:
	if not is_active:
		return

	await get_tree().create_timer(creature.spawn_time).timeout
	var new_creature: Node2D = load(creature.scene_path).instantiate()
	spawn_to.add_child(new_creature)
	new_creature.global_position = global_position

	print("INFO: Spawned %s at %s" % [creature.id, global_position])

	spawn()


func _set_is_active(new_value) -> void:
	var previous_value := is_active
	is_active = new_value

	if previous_value == false and new_value == true:
		spawn()
