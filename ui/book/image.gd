class_name UIImage
extends PanelContainer


@onready var texture_rect: TextureRect = %TextureRect


func set_image(image: Image) -> void:
	texture_rect.texture = ImageTexture.create_from_image(image)
