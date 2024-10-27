# TODO: This main ref stuff need refactoring as well as all the spawn_to_main stuff.
class_name SpawnerComponent
extends Node2D


@export var creature: CreatureGlobalData
@export var habitat: HabitatComponent
@export var habitat_position: CreaturePositionComponent
@export var spawn_to: Node
@export var constructions_spawn_to: Node
@export var constructions_spawn_to_main := false
## Spawn the creature to the main scenes bee node
@export var spawn_to_main_bees := false
## If true creatures will spawn on the location of the spawner
@export var local := false
@export var override_creature_spawn_time := -1.0
@export var spawn_count := 10
@export var use_spawn_count := false
@export var is_active := false:
	set = _set_is_active

var camera: Camera2D
var spawn_offset_min: int
var spawn_offset_max: int
var creatures_spawned := 0

func spawn() -> void:
	if not is_active:
		return

	if override_creature_spawn_time == -1:
		await get_tree().create_timer(creature.spawn_time).timeout
	else:
		await get_tree().create_timer(override_creature_spawn_time).timeout

	var random_position: Vector2
	var new_creature: BeeComponent = load(creature.scene_path).instantiate()

	if not local:
		var camera_view_size := Utils.get_camera_view_size(camera)

		var multiplier_x := 1 if randf() > 0.5 else -1
		var random_x: int = (randi_range(spawn_offset_min, spawn_offset_max) + camera_view_size.x) * multiplier_x
		var multiplier_y := 1 if randf() > 0.5 else -1
		var random_y: int = (randi_range(spawn_offset_min, spawn_offset_max) + camera_view_size.y) * multiplier_y
		random_position = Vector2(random_x, random_y)
		spawn_to.add_child(new_creature)

	if spawn_to_main_bees:
		Global.main_ref.bees.add_child(new_creature)

	new_creature.global_position = global_position if local else random_position

	if habitat:
		new_creature.data.current_habitat = habitat

	if habitat_position:
		new_creature.data.current_habitat_position = habitat_position

	if camera:
		new_creature.movement.target = Vector2(camera.global_position)
	else:
		new_creature.search()

	var digging_component: DiggingComponent = new_creature.get("digging")
	if digging_component:
		if constructions_spawn_to_main:
			digging_component.spawn_to = Global.main_ref.constructed
		else:
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

	if use_spawn_count:
		if creatures_spawned >= spawn_count:
			is_active = false
		else:
			creatures_spawned += 1

	spawn()


func _set_is_active(new_value) -> void:
	var previous_value := is_active
	is_active = new_value

	if previous_value == false and new_value == true:
		spawn()
