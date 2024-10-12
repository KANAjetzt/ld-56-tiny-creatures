extends Node


@export var sprite: Sprite2D
@export var movement: MovementComponent


func _process(delta: float) -> void:
	if movement.direction.x > 0:
		sprite.flip_h = true
	elif movement.direction.x < 0:
		sprite.flip_h = false
