class_name UIHUD
extends AspectRatioContainer


signal placeable_selected(data: PlaceableGlobalData)

var is_hovering := false

@onready var toast: ToastUI = %Toast


func _ready() -> void:
	Global.unlocked_placeable.connect(_on_global_unlocked_placeable)


func _on_fly_in_hover_changed(_is_hovering: bool) -> void:
	is_hovering = _is_hovering


func _on_placeables_placeable_selected(data: PlaceableGlobalData) -> void:
	placeable_selected.emit(data)


func _on_global_unlocked_placeable(data: PlaceableGlobalData) -> void:
	toast.add(data.icon, "Unlocked %s" % data.display_name)
