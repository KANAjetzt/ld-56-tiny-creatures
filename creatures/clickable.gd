class_name ClickableComponent
extends Node2D


signal clicked_on(bee: BeeComponent)

@export var bee: BeeComponent

var is_hovering := false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("place") and is_hovering:
		clicked_on.emit(bee)
		Global.current_focused_creature = bee

		if not bee.data_global in Global.currently_discovered_creatures:
			Global.new_creature_discovered(bee.data_global)


func _on_mouse_entered() -> void:
	is_hovering = true


func _on_mouse_exited() -> void:
	is_hovering = false
