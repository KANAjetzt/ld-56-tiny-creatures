class_name PlaceableData
extends Resource


signal current_amount_changed(data: PlaceableData)
signal got_unlocked(data: PlaceableData)

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
@export var amount_max := 3
@export_dir var scene_path: String
@export var is_unlocked := true:
	set = _set_is_unlocked

# TODO: rename to amount_current
var current_amount := amount_max:
	set = _set_current_amount
var needs_resupply := false:
	set = _set_needs_resupply


func resupply() -> void:
	if needs_resupply:
		var timer := Utils.create_timer(resupply_time).timeout.connect(_on_resupply_timer_timeout)


func _set_current_amount(new_value) -> void:
	current_amount = new_value

	if current_amount < amount_max:
		needs_resupply = true

	if current_amount == amount_max:
		needs_resupply = false

	current_amount_changed.emit(self)


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


func _on_resupply_timer_timeout() -> void:
	current_amount += 1
	resupply()
