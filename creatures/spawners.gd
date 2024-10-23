class_name SpawnersComponent
extends Node2D


@export var camera: Camera2D
@export var spawner_scene: PackedScene
@export var spawn_to: Node
@export var constructions_spawn_to: Node
@export var spawn_offset_min := 50
@export var spawn_offset_max := 200


func _ready() -> void:
	Global.criteria_met.connect(_on_criteria_met)
	Global.criteria_no_longer_met.connect(_on_criteria_no_longer_met)


func add_spawner(creature: CreatureData) -> void:
	var new_spawner: SpawnerComponent = spawner_scene.instantiate()
	new_spawner.name = creature.id
	add_child(new_spawner)
	new_spawner.spawn_to = spawn_to
	new_spawner.constructions_spawn_to = constructions_spawn_to
	new_spawner.creature = creature
	new_spawner.camera = camera
	new_spawner.spawn_offset_min = spawn_offset_min
	new_spawner.spawn_offset_max = spawn_offset_max
	new_spawner.is_active = true


func _on_criteria_met(creature: CreatureData) -> void:
	print("INFO: Added spawner for %s" % creature.id)
	add_spawner(creature)


func _on_criteria_no_longer_met(creature: CreatureData) -> void:
	print("INFO: Removed spawner for %s" % creature.id)
	var spawner: SpawnerComponent = get_node(creature.id)
	spawner.queue_free()
