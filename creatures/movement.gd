class_name MovementComponent
extends Node2D


signal target_reached

@export var parent: Node2D
@export var speed := 2000
@export var speed_multiplier := 1.0
@export var min_distance_to_target := 50

var target: Vector2:
	set(new_value):
		target = new_value
		is_at_target = false
var is_at_target := false
var direction: Vector2


func _physics_process(delta: float) -> void:
	direction = parent.global_position.direction_to(target)
	var movement := direction * speed * speed_multiplier * delta

	if parent.global_position.distance_squared_to(target) > min_distance_to_target:
		parent.global_position += movement
	else:
		parent.global_position = target
		if not is_at_target:
			is_at_target = true
			target_reached.emit()
