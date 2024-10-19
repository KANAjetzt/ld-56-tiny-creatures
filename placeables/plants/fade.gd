class_name FadeComponent
extends Node


signal fade_in_finished
signal fade_out_finished


@export var node: Node2D
@export var time := 2.0
@export var start_scale: Vector2
@export var auto_start := true

@onready var original_scale := Vector2(node.scale)
@onready var original_alpha := node.modulate.a

func _ready() -> void:
	if auto_start:
		fade_in()


func fade_in() -> void:
	node.scale = start_scale
	node.modulate.a = 0.0
	node.show()
	var tween := create_tween()
	tween.tween_property(node, "scale", original_scale, time)
	tween.parallel().tween_property(node, "modulate:a", original_alpha, time)
	await tween.finished
	fade_in_finished.emit()


func fade_out() -> void:
	var tween := create_tween()
	tween.tween_property(node, "scale", start_scale, time)
	tween.parallel().tween_property(node, "modulate:a", 0.0, time)
	await tween.finished
	node.hide()
	fade_out_finished.emit()
