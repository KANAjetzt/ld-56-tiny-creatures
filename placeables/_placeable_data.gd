class_name PlaceableData
extends Resource


@export var id: String
@export var display_name: String
@export var icon: CompressedTexture2D
@export var is_attractor := true
@export var is_habitat := false
@export var wait_time := 1.0
@export var amount_max := 3
@export_dir var scene_path: String


var current_amount := amount_max
