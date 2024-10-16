class_name BeeSoundComponent
extends AudioStreamPlayer2D


@export var pitch_min: float = 0.95
@export var pitch_max: float = 1.05


func _ready() -> void:
	pitch_scale = randf_range(pitch_min, pitch_max)
