class_name PlaceableGlobalData
extends Resource


signal got_unlocked(data: PlaceableGlobalData)
signal amount_current_changed(data: PlaceableGlobalData)

@export var id: String
@export var display_name: String
@export var icon: CompressedTexture2D
@export var is_attractor := true
@export var is_habitat := false
## True if the habitat is constructed by the creature
@export var is_habitat_construction := false
@export var is_plant := true
## The time the creature will stay
@export var wait_time := 1.0
## The time in seconds it takes to resuppy one
@export var resupply_time := 30.0
@export var amount_start := 3:
	set = _set_amount_start
@export var amount_max := 3
@export_dir var scene_path: String
@export var is_unlocked := true:
	set = _set_is_unlocked

var amount_current := amount_start:
	set = _set_amount_current
var needs_resupply := false:
	set = _set_needs_resupply


func resupply() -> void:
	if needs_resupply and Utils:
		Utils.create_timer(resupply_time).timeout.connect(_on_resupply_timer_timeout)


func _set_amount_current(new_value) -> void:
	amount_current = new_value

	if amount_current < amount_max:
		needs_resupply = true

	if amount_current == amount_max:
		needs_resupply = false

	amount_current_changed.emit(self)


func _set_needs_resupply(new_value) -> void:
	var previous_value := needs_resupply
	needs_resupply = new_value
	# If previously there was no need for resupply start resuppling
	if new_value == true and previous_value == false:
		resupply()


func _set_is_unlocked(new_value) -> void:
	var previous_value := is_unlocked
	is_unlocked = new_value
	# If previously there was no need for resupply start resuppling
	if new_value == true and previous_value == false:
		got_unlocked.emit(self)


func _set_amount_start(new_value) -> void:
	amount_start = new_value
	amount_current = amount_start


func _on_resupply_timer_timeout() -> void:
	amount_current += 1
	resupply()
