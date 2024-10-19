class_name BeeSoundComponent
extends AudioStreamPlayer2D


@export var pitch_min: float = 0.95
@export var pitch_max: float = 1.05
@export var fade_in_time := 0.45
@export var fade_out_time := 0.45

@onready var original_db := volume_db


func _ready() -> void:
	pitch_scale = randf_range(pitch_min, pitch_max)


func fade_in(db := original_db) -> void:
	var tween := create_tween()
	tween.tween_property(self, "volume_db", db, fade_in_time)


func fade_out(db := -40) -> void:
	var tween := create_tween()
	tween.tween_property(self, "volume_db", db, fade_out_time)
