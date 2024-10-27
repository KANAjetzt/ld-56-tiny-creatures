extends Node


signal criteria_met(creature: CreatureGlobalData)
signal criteria_no_longer_met(creature: CreatureGlobalData)
signal creature_discovered(creature: CreatureGlobalData)
signal creature_focused(creature_node: BeeComponent)
signal creature_unfocused

@export var placeables: Array[PlaceableGlobalData]
@export var creatures: Array[CreatureGlobalData]

var currently_selected_placeable: PlaceableGlobalData
var current_habitats: Dictionary = {}
var currently_placed_plants: Dictionary = {}
var current_creatures_with_met_criteria: Array[CreatureGlobalData]
var currently_discovered_creatures: Array[CreatureGlobalData]
var creature_count: Dictionary = {}
var current_focused_creature: BeeComponent:
	set = _set_current_focused_creature

## Set by [CameraTarget]
var zoom_in_max: Vector2
var zoom_out_max: Vector2

var main_ref: Node2D


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("show_debug_panels"):
		for panel in get_tree().get_nodes_in_group("debug_panel"):
			panel.show()

	if event.is_action_pressed("hide_debug_panels"):
		for panel in get_tree().get_nodes_in_group("debug_panel"):
			panel.hide()


func check_creature_criteria() -> void:
	for creature in creatures:
		var found_habitat := false
		var found_plants := false
		var found_plant_count := 0

		# Habitat Check
		var habitat_space := 0
		for habitat in creature.habitats:
			if current_habitats.has(habitat.id):
				habitat_space += current_habitats[habitat.id].space_free
			elif habitat.is_habitat_construction:
				current_habitats[habitat.id] = HabitatSpaceData.new(1)

		# If there is free habitat space and there is no creature with that id there is enough space for them.
		if habitat_space > 0 or creature.habitats.is_empty():
			found_habitat = true

		# Plant Check
		for plant_id in creature.plants:
			if not currently_placed_plants.has(plant_id):
				continue
			if currently_placed_plants[plant_id] >= creature.plants[plant_id]:
					found_plant_count += 1

		found_plants = found_plant_count == creature.plants.size()

		if not creature in current_creatures_with_met_criteria:
			if found_habitat and found_plants:
				creature_criteria_met(creature)

		if creature in current_creatures_with_met_criteria:
			if not found_habitat or not found_plants:
				creature_criteria_no_longer_met(creature)


func creature_criteria_met(creature: CreatureGlobalData):
	print("INFO: Creature criteria met for %s" % creature.id)
	current_creatures_with_met_criteria.push_back(creature)
	criteria_met.emit(creature)


func creature_criteria_no_longer_met(creature: CreatureGlobalData):
	print("INFO: Creature criteria no longer met for %s" % creature.id)
	current_creatures_with_met_criteria.erase(creature)
	criteria_no_longer_met.emit(creature)


func new_creature_discovered(creature: CreatureGlobalData) -> void:
	currently_discovered_creatures.push_back(creature)
	creature_discovered.emit(creature)


func _set_current_focused_creature(new_value) -> void:
	current_focused_creature = new_value
	if current_focused_creature:
		creature_focused.emit(new_value)
	else:
		creature_unfocused.emit()
