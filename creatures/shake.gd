class_name ShakeComponent
extends Node


@export var sprite: Sprite2D
@export var is_active := true:
	set = _set_is_active
@export var speed := 0.5
@export var range := 10


func _ready() -> void:
	if is_active:
		start()


func start() -> void:
	if is_active:
		var random_speed := randf_range(speed * 0.4, speed * 1.6)
		var random_range := randi_range(range * 0.4, range * 1.6)

		var tween := create_tween()
		tween.tween_property(sprite, "offset:y", sprite.offset.y + random_range, random_speed * 0.5).as_relative()
		tween.tween_property(sprite, "offset:y", sprite.offset.y - random_range, random_speed * 0.5).as_relative()
		tween.tween_callback(start)


func _set_is_active(new_value) -> void:
	var previous_value := is_active
	is_active = new_value

	if previous_value == false and new_value == true:
		start()
