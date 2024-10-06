class_name AttractorArea
extends Area2D


@export var ref: AttractorComponent


func _ready() -> void:
	if ref:
		set_meta("ref", ref)
	else:
		print("WARNING: No ref set!")
