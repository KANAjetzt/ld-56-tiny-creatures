class_name TaskObserverComponent
extends Node


@export var bee: BeeComponent

var is_observing := false


func _ready() -> void:
	Global.creature_focused.connect(_on_global_creature_focused)
	Global.creature_unfocused.connect(_on_global_creature_unfocused)

	bee.collected_pollen.connect(_on_bee_collected_pollen)
	bee.delivered_pollen.connect(_on_bee_delivered_pollen)
	bee.found_habitat.connect(_on_bee_found_habitat)
	bee.entered_habitat.connect(_on_bee_entered_habitat)

	bee.data_global.tasks.all_tasks_completed.connect(_on_tasks_all_tasks_completed)


func check_pollen_collected_tasks() -> void:
	for task in bee.data_global.tasks.pollen_collect:
		if task.is_completed:
			continue
		if bee.data.current_local_data.id == task.plant.id:
			task.is_completed = true
			print("INFO: \"%s\" completed." % task.id)


func check_habitat_delivered_tasks() -> void:
	for task in bee.data_global.tasks.habitat_deliver:
		if task.is_completed:
			continue
		if bee.data.current_local_data == bee.data.current_habitat.data_global:
			task.is_completed = true
			print("INFO: \"%s\" completed." % task.id)


func check_habitat_found_tasks() -> void:
	for task in bee.data_global.tasks.habitat_find:
		if task.is_completed:
			continue
		if bee.data.current_habitat and bee.data.current_habitat.data_global == bee.data.current_local_data:
			task.is_completed = true
			print("INFO: \"%s\" completed." % task.id)


func _on_global_creature_focused(_bee: BeeComponent) -> void:
	if _bee == bee:
		is_observing = true


func _on_global_creature_unfocused() -> void:
	is_observing = false


func _on_bee_collected_pollen(_bee: BeeComponent) -> void:
	if is_observing:
		check_pollen_collected_tasks()


func _on_bee_found_habitat(_bee: BeeComponent) -> void:
	if is_observing:
		check_habitat_found_tasks()


func _on_bee_entered_habitat(_bee: BeeComponent) -> void:
	pass


func _on_bee_delivered_pollen(_bee: BeeComponent) -> void:
	if is_observing:
		check_habitat_delivered_tasks()


func _on_tasks_all_tasks_completed() -> void:
	for placeable in bee.data_global.unlocks_placeable:
		placeable.is_unlocked = true
