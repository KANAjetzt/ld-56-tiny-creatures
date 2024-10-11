class_name GrowComponent
extends Node


@export var node: Node2D
@export var time := 2.0
@export var start_scale: Vector2


func _ready() -> void:
	var original_scale := Vector2(node.scale)
	node.scale = start_scale
	node.modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(node, "scale", original_scale, time)
	tween.parallel().tween_property(node, "modulate:a", 1.0, 1.0)
