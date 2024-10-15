extends Node


@export var tracks: Array[AudioStream] = []
@export var wait_time_min: int = 25
@export var wait_time_max: int = 60

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	play_random()


func play_random() -> void:
	if not audio_stream_player.playing:
		var random_wait_time := randi_range(wait_time_min, wait_time_max)
		print("waiting for %s before playing" % random_wait_time)
		await get_tree().create_timer(random_wait_time).timeout
		var track: AudioStream = tracks.pick_random()
		audio_stream_player.stream = track
		var tween := create_tween()
		audio_stream_player.volume_db = -30
		audio_stream_player.play()
		tween.tween_property(audio_stream_player, "volume_db", 0.0, 5.0).set_ease(Tween.EASE_OUT)


func _on_audio_stream_player_finished() -> void:
	play_random()
