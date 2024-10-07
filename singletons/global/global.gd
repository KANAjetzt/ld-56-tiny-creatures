extends Node


signal criteria_met(creature: CreatureData)
signal criteria_no_longer_met(creature: CreatureData)

@export var placeables: Array[PlaceableData]
@export var creatures: Array[CreatureData]

var currently_selected_placeable: PlaceableData
var current_habitats_free: Dictionary[String, Array] = {}
var currently_placed_plants: Dictionary[PlaceableData, int] = {}
var current_creatures_with_met_criteria: Array[CreatureData]


func check_creature_criteria() -> void:
	for creature in creatures:
		var found_habitat := false
		var found_plants := false
		var found_plant_count := 0

		for habitat in creature.habitats:
			if current_habitats_free.has(habitat.id):
				found_habitat = true

		for plant in creature.plants:
			if not currently_placed_plants.has(plant):
				continue
			if currently_placed_plants[plant] >= creature.plants[plant]:
					found_plant_count += 1

		found_plants = found_plant_count == creature.plants.size()

		if not creature in current_creatures_with_met_criteria:
			if found_habitat and found_plants:
				creature_criteria_met(creature)

		if creature in current_creatures_with_met_criteria:
			if not found_habitat or not found_plants:
				creature_criteria_no_longer_met(creature)


func creature_criteria_met(creature: CreatureData):
	print("INFO: Creature criteria met for %s" % creature.id)
	current_creatures_with_met_criteria.push_back(creature)
	criteria_met.emit(creature)


func creature_criteria_no_longer_met(creature: CreatureData):
	print("INFO: Creature criteria no longer met for %s" % creature.id)
	current_creatures_with_met_criteria.erase(creature)
	criteria_no_longer_met.emit(creature)
