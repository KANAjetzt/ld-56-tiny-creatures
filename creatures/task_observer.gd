class_name TaskObserverComponent
extends Node


@export var bee: BeeComponent

var is_observing := false
var global_bee_data: CreatureData

func _ready() -> void:
	global_bee_data = Utils.get_global_creature_data(bee.data)

	Global.creature_focused.connect(_on_global_creature_focused)
	Global.creature_unfocused.connect(_on_global_creature_unfocused)

	bee.collected_pollen.connect(_on_bee_collected_pollen)
	bee.delivered_pollen.connect(_on_bee_delivered_pollen)
	bee.found_habitat.connect(_on_bee_found_habitat)
	bee.entered_habitat.connect(_on_bee_entered_habitat)


func task_bee_mason_habitat_snail() -> void:
	pass


func task_bee_mason_grass() -> void:
	pass


func task_bee_mason_lavender() -> void:
	pass


func task_bee_mason_deliver() -> void:
	pass


func _on_global_creature_focused(_bee: BeeComponent) -> void:
	if _bee == bee:
		is_observing = true


func _on_global_creature_unfocused() -> void:
	is_observing = false


func _on_bee_collected_pollen(_bee: BeeComponent) -> void:
	pass


func _on_bee_found_habitat(_bee: BeeComponent) -> void:
	pass


func _on_bee_entered_habitat(_bee: BeeComponent) -> void:
	pass


func _on_bee_delivered_pollen(_bee: BeeComponent) -> void:
	pass
