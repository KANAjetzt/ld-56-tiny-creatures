extends Node2D


@export var speed := 750
@export_range(0.0, 10.0, 0.01) var speed_multiplier := 1.0

@export var zoom_out_max := Vector2(0.3, 0.3)
@export var zoom_in_max := Vector2(50.0, 50.0)
@export var zoom_target_speed_curve: Curve

@onready var camera_main: PhantomCamera2D = %CameraMain


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("zoom_in"):
		if camera_main.zoom <= zoom_in_max:
			camera_main.zoom *= 1.1
			speed_multiplier = zoom_target_speed_curve.sample(camera_main.zoom.x / zoom_in_max.x)

	if Input.is_action_just_pressed("zoom_out"):
		if camera_main.zoom >= zoom_out_max:
			camera_main.zoom *= 0.9
			speed_multiplier = zoom_target_speed_curve.sample(camera_main.zoom.x / zoom_in_max.x)

	var direction := Input.get_vector("left", "right", "up", "down")
	if not direction == Vector2.ZERO:
		position += direction * speed * speed_multiplier * delta
