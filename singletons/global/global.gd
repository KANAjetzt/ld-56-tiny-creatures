extends Node


signal criteria_met(creature: CreatureData)
signal criteria_no_longer_met(creature: CreatureData)

@export var placeables: Array[PlaceableData]
@export var creatures: Array[CreatureData]

var currently_selected_placeable: PlaceableData
var current_habitats_free: Dictionary[String, Array] = {}
var current_creatures_with_met_criteria: Array[CreatureData]


func check_creature_criteria() -> void:
	for creature in creatures:
		var found_habitat := false

		for habitat in creature.habitats:
			if current_habitats_free.has(habitat.id):
				found_habitat = true
				if not creature in current_creatures_with_met_criteria:
					creature_criteria_met(creature)

		if not found_habitat:
			creature_criteria_no_longer_met(creature)


func creature_criteria_met(creature: CreatureData):
	current_creatures_with_met_criteria.push_back(creature)
	criteria_met.emit(creature)


func creature_criteria_no_longer_met(creature: CreatureData):
	current_creatures_with_met_criteria.erase(creature)
	criteria_no_longer_met.emit(creature)
