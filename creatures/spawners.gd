class_name SpawnersComponent
extends Node2D


@export var camera: Camera2D
@export var spawner_scene: PackedScene
@export var spawn_to: Node
@export var spawn_offset_min := 50
@export var spawn_offset_max := 200


func _ready() -> void:
	Global.criteria_met.connect(_on_criteria_met)
	Global.criteria_no_longer_met.connect(_on_criteria_no_longer_met)


func add_spawner(creature: CreatureData) -> void:
	var viewport_size = camera.get_viewport_rect().size
	var zoom = camera.zoom
	var view_size = Vector2(
		viewport_size.x * zoom.x,
		viewport_size.y * zoom.y
	)

	var random_x: int = randf() * spawn_offset_max + view_size.x + spawn_offset_min
	var random_y: int = randf() * spawn_offset_max + view_size.y + spawn_offset_min

	var new_spawner: SpawnerComponent = spawner_scene.instantiate()
	new_spawner.name = creature.id
	add_child(new_spawner)
	new_spawner.spawn_to = spawn_to
	new_spawner.creature = creature
	new_spawner.position = Vector2(random_x, random_y)
	new_spawner.is_active = true


func _on_criteria_met(creature: CreatureData) -> void:
	print("INFO: Added spawner for %s" % creature.id)
	add_spawner(creature)


func _on_criteria_no_longer_met(creature: CreatureData) -> void:
	print("INFO: Removed spawner for %s" % creature.id)
	var spawner: SpawnerComponent = get_node(creature.id)
	spawner.queue_free()
