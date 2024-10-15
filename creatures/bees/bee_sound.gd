extends AudioStreamPlayer2D


@export var zoom_db_curve: Curve
@export var pitch_min: float = 0.95
@export var pitch_max: float = 1.05


func _ready() -> void:
	pitch_scale = randf_range(pitch_min, pitch_max)


func _process(delta: float) -> void:
	var camera := get_viewport().get_camera_2d()

	var t = camera.zoom.x / Global.zoom_in_max.x
	volume_db = zoom_db_curve.sample_baked(t)
