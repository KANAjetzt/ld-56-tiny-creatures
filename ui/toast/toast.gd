class_name ToastUI
extends PanelContainer


@onready var image: UIImage = %Image
@onready var label: Label = %Label

var toast_queue := []


func _ready() -> void:
	hide()


func add(_texture: Texture, _text: String) -> void:
	toast_queue.push_back({"texture": _texture, "text": _text})
	if toast_queue.size() == 1:
		fly_in()


func fly_in() -> void:
	var current_toast = toast_queue[0]
	image.set_texture(current_toast.texture)
	label.text = current_toast.text
	position.y = 0 + size.y

	show()
	var tween := create_tween()
	tween.tween_property(self, "position:y", 0 - size.y, 0.2).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", 0 + size.y, 0.2).set_delay(2.0).set_ease(Tween.EASE_OUT)
	await tween.finished
	toast_queue.pop_front()
	hide()
	if toast_queue.size() > 0:
		fly_in()
