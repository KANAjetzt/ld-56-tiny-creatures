class_name CreatureData
extends Resource


enum STATE {IDLE, SEARCHING, TRAVEL}


@export var id: String
@export var display_name: String
@export var icon: CompressedTexture2D
@export var habitats: Array[PlaceableData]

var current_state := STATE.IDLE
var current_local: PlaceableData
var current_habitat: Node2D
