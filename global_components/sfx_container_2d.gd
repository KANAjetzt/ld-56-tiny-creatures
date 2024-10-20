class_name SFXContainer2D
extends Node2D


@export var sounds: Array[AudioStream] = []
@export var sounds_db_reduction := 0
@export var sounds_db_shift_enabled := false
@export var sounds_min_db := -5
@export var sounds_max_db := 0
@export var sounds_pitch_shift_enabled := false
@export var sounds_pitch_min := 0.95
@export var sounds_pitch_max := 1.05
@export var sounds_transition_enalbed := false
@export var sounds_transition_time := 0.5
## Components that get added to each spawned sound.
@export var audio_stream_player_to_use: AudioStreamPlayer2D
@export var bus_to_use: StringName = &"SFX"
@export var global_spawn_position_node: Node2D
@export var global_spawn_container_node: Node
@export var spawn_local := true
@export var spawn_global := true
@export var spawn_global_offset_min := 50
@export var spawn_global_offset_max := 500
@export var spawn_frequenzy := 0.5
@export var spawn_enabled := true
@export var visualize_sound_spawn := false

@onready var sprite_2d: Sprite2D = $Template/Sprite2D


func _ready() -> void:
	if visualize_sound_spawn:
		for child in get_children():
			if child is Sprite2D:
				child.show()

	start()


func start() -> void:
	spawn_enabled = true
	spawn_sound()


func spawn_sound() -> void:
	if not spawn_enabled:
		return

	await get_tree().create_timer(spawn_frequenzy).timeout

	if sounds.is_empty():
		assert(false, "Please add sounds.")

	if spawn_global:
		if global_spawn_position_node == null:
			assert(false, "Make sure to add a global_spawn_position_node.")
			return

		if global_spawn_container_node == null:
			assert(false, "Make sure to add a global_spawn_container_node.")
			return

		var new_audio_stream_player_2d := get_new_audio_stream_player_2d()

		global_spawn_container_node.add_child(new_audio_stream_player_2d)
		var random_offset := randi_range(spawn_global_offset_min, spawn_global_offset_max)
		var is_offset_negative := randf() > 0.5
		if is_offset_negative:
			random_offset *= -1
		new_audio_stream_player_2d.global_position = global_spawn_position_node.global_position + Vector2(random_offset, random_offset)
		new_audio_stream_player_2d.stream = sounds.pick_random()
		play_sound(new_audio_stream_player_2d)

	if spawn_local:
		var new_audio_stream_player_2d := get_new_audio_stream_player_2d()
		get_children().pick_random().add_child(new_audio_stream_player_2d)
		new_audio_stream_player_2d.stream = sounds.pick_random()
		play_sound(new_audio_stream_player_2d)

	spawn_sound()


func play_sound(audio_stream_player_2d: AudioStreamPlayer2D) -> void:
	if sounds_transition_enalbed:
		var original_db := audio_stream_player_2d.volume_db
		audio_stream_player_2d.volume_db = -30
		var tween := create_tween()
		tween.tween_property(audio_stream_player_2d, "volume_db", original_db, sounds_transition_time)
		audio_stream_player_2d.play()
	else:
		audio_stream_player_2d.play()



func get_new_audio_stream_player_2d() -> AudioStreamPlayer2D:
	var new_audio_stream_player_2d: AudioStreamPlayer2D

	if audio_stream_player_to_use:
		new_audio_stream_player_2d = audio_stream_player_to_use.duplicate()
	else:
		new_audio_stream_player_2d = AudioStreamPlayer2D.new()

	if sounds_pitch_shift_enabled:
		new_audio_stream_player_2d.pitch_scale = randf_range(sounds_pitch_min, sounds_pitch_max)
	if sounds_db_shift_enabled:
		new_audio_stream_player_2d.volume_db = randf_range(sounds_min_db, sounds_max_db)
	new_audio_stream_player_2d.volume_db -= sounds_db_reduction
	new_audio_stream_player_2d.panning_strength = 1.8
	new_audio_stream_player_2d.bus = bus_to_use
	new_audio_stream_player_2d.finished.connect(_on_audio_stream_player_2d_finished.bind(new_audio_stream_player_2d))

	if visualize_sound_spawn:
		var sprite: Sprite2D = sprite_2d.duplicate()
		new_audio_stream_player_2d.add_child(sprite)
		sprite.show()

	return new_audio_stream_player_2d


func _on_audio_stream_player_2d_finished(audio_stream_player: AudioStreamPlayer2D) -> void:
	audio_stream_player.queue_free()
