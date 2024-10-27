class_name UIPlaceablePreview
extends Sprite2D


func _process(_delta: float) -> void:
	if texture:
		global_position = get_global_mouse_position() + Vector2(20, -15)


func set_preview(preview_texture: Texture) -> void:
	texture = preview_texture


func remove_preview() -> void:
	texture = null
