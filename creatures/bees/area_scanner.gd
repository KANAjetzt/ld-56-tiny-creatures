class_name AreaScannerComponent
extends Area2D


signal area_detected(area: Area2D)

@export var search_for: Dictionary
@export var ignore_if_habitat_close_by := true


func _physics_process(_delta: float) -> void:
	var found_plants := {}
	var ignore := false

	var areas := get_overlapping_areas()

	for area in areas:
		if area is AttractorArea and area.ref.habitat and ignore_if_habitat_close_by:
			ignore = true
			break

		if area is AttractorArea and area.ref.plant:
			var plant_id: String = area.ref.plant.data.id

			if not search_for.has(plant_id):
				continue

			if not found_plants.has(plant_id):
				found_plants[plant_id] = {
					"count": 0,
					"area": area,
				}

			found_plants[plant_id].count += 1

	if not ignore:
		for plant_id in search_for:
			if found_plants.has(plant_id) and found_plants[plant_id].count >= search_for[plant_id]:
				area_detected.emit(found_plants[plant_id].area)
