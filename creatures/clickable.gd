class_name ClickableComponent
extends Node2D


signal clicked_on

@export var bee: BeeComponent

var is_hovering := false


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("place") and is_hovering:
		clicked_on.emit()
		Global.current_focused_creature = bee
		var global_bee_data = Global.creatures.filter(
			func get_bee(creature_data: CreatureData) -> bool:
				if creature_data.id == bee.data.id:
					return true

				return false
		)[0]

		if not global_bee_data in Global.currently_discovered_creatures:
			Global.new_creature_discovered(global_bee_data)


func _on_mouse_entered() -> void:
	is_hovering = true


func _on_mouse_exited() -> void:
	is_hovering = false
