class_name CreatureData
extends Resource


signal current_local_data_changed(current_local_data: PlaceableGlobalData)


var current_local: Node
var current_local_position: CreaturePositionComponent
var current_local_data: PlaceableGlobalData:
	set = _set_current_local_data
var current_habitat: HabitatComponent
var current_habitat_position: CreaturePositionComponent


func _set_current_local_data(new_value) -> void:
	current_local_data = new_value
	current_local_data_changed.emit(new_value)
