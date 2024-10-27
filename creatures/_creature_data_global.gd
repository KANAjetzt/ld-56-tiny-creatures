class_name CreatureGlobalData
extends Resource


@export var id: String
@export var display_name: String
@export var icon: CompressedTexture2D
@export var habitats: Array[PlaceableData]
@export var plants: Dictionary
## Add `plant_id: count` to add to the spawn requirement each time the creature is spawned.
@export var plants_per_spawn: Dictionary
@export_dir var scene_path: String
@export var spawn_time: float = 5.0
@export_multiline var info_text: String
@export var tasks: TasksData:
	set = _set_tasks
## Add placeables that are unlocked if all tasks are completed
@export var unlocks_placeable: Array[PlaceableData] = []

var images: Array[Image] = []
var is_discovered := false


func _set_tasks(new_value) -> void:
	tasks = new_value
	if not tasks.is_initialized:
		tasks.init()
