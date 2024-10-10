class_name CreaturePositionComponent
extends Node2D


@export var is_occupied := false
@export var pollen_container: PollenContainerComponent

var parent: CreaturePositionsComponent


func _ready() -> void:
	if get_parent() is CreaturePositionsComponent:
		parent = get_parent()
	else:
		assert("CreaturePositionComponent must be a child of CreaturePositionsComponent")


func clear() -> void:
	parent.free_position(self)
