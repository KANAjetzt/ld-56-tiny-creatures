class_name CreatureData
extends Resource


enum STATE {IDLE, SEARCHING, TRAVEL}


@export var id: String
@export var display_name: String
@export var icon: CompressedTexture2D
@export var habitats: Array[PlaceableData]
@export var plants: Dictionary
@export_dir var scene_path: String
@export var spawn_time: float = 5.0
@export_multiline var info_text: String

var current_state := STATE.IDLE
var current_local: Node
var current_local_position: CreaturePositionComponent
var current_local_data: PlaceableData
var current_habitat: HabitatComponent
var current_habitat_position: CreaturePositionComponent
var is_discovered := false
