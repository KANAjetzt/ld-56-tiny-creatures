class_name CreatureData
extends Resource


enum STATE {IDLE, SEARCHING, TRAVEL}

signal current_local_data_changed(current_local_data: PlaceableData)

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

var current_state := STATE.IDLE
var current_local: Node
var current_local_position: CreaturePositionComponent
var current_local_data: PlaceableData:
	set = _set_current_local_data
var current_habitat: HabitatComponent
var current_habitat_position: CreaturePositionComponent
var is_discovered := false


func _set_current_local_data(new_value) -> void:
	current_local_data = new_value
	current_local_data_changed.emit(new_value)
