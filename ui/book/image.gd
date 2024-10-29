class_name UIImage
extends PanelContainer


@export var border := 0

@onready var texture_rect: TextureRect = %TextureRect
@onready var margin_container: MarginContainer = %MarginContainer


func _ready() -> void:
	margin_container.add_theme_constant_override(&"margin_left", border)
	margin_container.add_theme_constant_override(&"margin_top", border)
	margin_container.add_theme_constant_override(&"margin_right", border)
	margin_container.add_theme_constant_override(&"margin_bottom", border)


func set_image(image: Image) -> void:
	texture_rect.texture = ImageTexture.create_from_image(image)


func set_texture(texture: Texture) -> void:
	texture_rect.texture = texture
