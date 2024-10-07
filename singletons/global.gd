extends Node


signal placeable_placed(placeable: PlaceableData)

@export var placeables: Array[PlaceableData]

var currently_selected_placeable: PlaceableData
