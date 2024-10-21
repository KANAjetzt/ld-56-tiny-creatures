class_name BeeSoundComponent
extends AudioStreamPlayer2D


@export var pitch_min: float = 0.95
@export var pitch_max: float = 1.05
@export var fade_in_time := 0.45
@export var fade_out_time := 0.45

@onready var original_db := volume_db


var stoped_position: float


func _ready() -> void:
	pitch_scale = randf_range(pitch_min, pitch_max)


func fade_in(db := original_db) -> void:
	play(stoped_position if stoped_position else 0.0)
	var tween := create_tween()
	tween.tween_property(self, "volume_db", db, fade_in_time)


func fade_out(db := -40) -> void:
	original_db = volume_db
	var tween := create_tween()
	tween.tween_property(self, "volume_db", db, fade_out_time)
	await tween.finished
	stoped_position = get_playback_position()
	stop()
