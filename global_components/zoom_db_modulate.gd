extends Node


@export var audio_player: Node
@export var zoom_db_curve: Curve


func _ready() -> void:
	if audio_player == null or zoom_db_curve == null:
		assert(false, "Make sure to set audio_player and zoom_db_curve")
	if not audio_player is AudioStreamPlayer and not audio_player is AudioStreamPlayer2D:
		assert(false, "Only AudioStreamPlayer and AudioStreamPlayer2D are supported as audio_player.")


func _process(delta: float) -> void:
	var camera := get_viewport().get_camera_2d()

	if camera:
		var t = camera.zoom.x / Global.zoom_in_max.x
		audio_player.volume_db = zoom_db_curve.sample_baked(t)
