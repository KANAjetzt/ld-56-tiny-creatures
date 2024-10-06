class_name AttracteeComponent
extends Node2D


signal inside_attractor_area(attractor_area: AttractorArea)

@onready var area_2d: Area2D = %Area2D


func _ready() -> void:
	for area in area_2d.get_overlapping_areas():
		if area is AttractorArea:
			if not area.ref.creature_positions.all_occupied:
				inside_attractor_area.emit(area)


func _on_area_2d_area_entered(area: Area2D) -> void:
	inside_attractor_area.emit(area)
