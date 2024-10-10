class_name ClickableComponent
extends Node2D


signal clicked_on

@export var bee: BeeComponent

var is_hovering := false


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("place") and is_hovering:
		clicked_on.emit()
		if not bee.data in Global.currently_discovered_creatures:
			Global.new_creature_discovered(bee.data)


func _on_mouse_entered() -> void:
	is_hovering = true


func _on_mouse_exited() -> void:
	is_hovering = false
