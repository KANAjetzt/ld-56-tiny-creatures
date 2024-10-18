class_name PollenVisualsComponent
extends Sprite2D


@export var count: int = 5:
	set = _set_count
@export var radius: float = 0.078:
	set = _set_radius
@export var distance: float = 0.134:
	set = _set_distance
@export var color: Color = Color(0.856, 0.68, 0)
@export var pollen_container: PollenContainerComponent
@export var use_parent := false


func _ready() -> void:
	if use_parent:
		var parent: Node =  get_parent()

		if not parent is PollenContainerComponent:
			assert(false, "The parent has to be a Pollen Container.")
			return

		pollen_container = parent

	if pollen_container:
		global_position = pollen_container.global_position
		pollen_container.current_changed.connect(_on_pollen_container_current_changed)

	material = material.duplicate()


func _set_count(new_value) -> void:
	count = new_value
	material.set_shader_parameter("circle_count", count)


func _set_radius(new_value) -> void:
	radius = new_value
	material.set_shader_parameter("circle_radius", radius)


func _set_distance(new_value) -> void:
	distance = new_value
	material.set_shader_parameter("circle_distance", distance)


func _on_pollen_container_current_changed(current: int) -> void:
	count = current
