class_name UIHUD
extends MarginContainer


signal placeable_selected(data: PlaceableGlobalData)

var is_hovering := false


func _on_fly_in_hover_changed(_is_hovering: bool) -> void:
	is_hovering = _is_hovering


func _on_placeables_placeable_selected(data: PlaceableGlobalData) -> void:
	placeable_selected.emit(data)
