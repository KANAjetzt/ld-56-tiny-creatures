class_name DiggingComponent
extends Node


signal started
signal finished(spawn_habitat_callable: Callable)

@export var area_scanner: AreaScannerComponent
@export var movement: MovementComponent
@export var distance_to_detected_area_min := 10
@export var distance_to_detected_area_max := 20
@export var dig_time := 60.0
## Path to the scene that should spawn after digging
@export_dir var habitat_to_spawn: String

var is_area_detected := false
var is_digging := false
var dig_position: Vector2
var spawn_to: Node


# Find a space with at least 3 tall grass in close proximity
# Start digging for 60sec.
# Create a new habitat for 10 bumblebees


func _ready() -> void:
	if not area_scanner:
		assert(false, "Make sure to add an Area Scanner.")

	area_scanner.area_detected.connect(_on_area_scanner_area_detected)


func start(position: Vector2) -> void:
	started.emit()
	is_digging = true
	dig_position = Vector2(position) + Vector2(
		randi_range(distance_to_detected_area_min * 1 if randf() > 0.5 else -1, distance_to_detected_area_max * 1 if randf() > 0.5 else -1),
		randi_range(distance_to_detected_area_min * 1 if randf() > 0.5 else -1, distance_to_detected_area_max * 1 if randf() > 0.5 else -1),
	)
	movement.target = dig_position
	await movement.target_reached
	await get_tree().create_timer(dig_time).timeout
	finished.emit(spawn_habitat)
	spawn_habitat(spawn_to)


func spawn_habitat(parent: Node) -> void:
	var new_habitat: Placeable = load(habitat_to_spawn).instantiate()
	var habitat_component: HabitatComponent = new_habitat.habitat
	parent.add_child(new_habitat)
	new_habitat.global_position = dig_position

	if habitat_component.spawner:
		habitat_component.spawner.is_active = true

	is_digging = false


func _on_area_scanner_area_detected(area: AttractorArea) -> void:
	if not is_area_detected:
		print("uuhhhh nice %s!" % area)
		start(area.global_position)
	is_area_detected = true
