class_name PollenContainerComponent
extends Node2D


signal filled_up
signal emptied
signal current_changed(current: int)

@export var start := 0
@export var max := 5
@export var refills := false
@export var refill_time := 5.0
@export var depletes := false
@export var deplete_time := 5.0
@export var sprite: AnimatedSprite2D
## Use this to set a custom positions node
## The node should contain a child node for each position
## a pollen sprite should be added.
@export var positions: Node2D

var current := 0:
	set = _set_current
var is_full := false:
	set = _set_is_full
var is_empty := true:
	set = _set_is_empty

var debug_panel: UIDebugPanel
var debug_entry: UIDebugPanelEntry



func _ready() -> void:
	current = start
	debug_panel = get_node_or_null("%DebugPanel")

	if debug_panel:
		debug_entry = debug_panel.add_entry("Pollen count:", str(current))

	if refills:
		refill()


func give(amount: int = 1) -> int:
	# If there is enough return the amount given
	if current - amount >= 0:
		current -= amount
		return amount
	# If container is empty
	elif current == 0:
		return -1
	# If there is not enough return the remaining
	elif current - amount < 0:
		var remaining = current
		current = 0
		return remaining

	assert(false, "No case was hit - something is wrong.")
	return -1


func give_all() -> int:
	return give(current)


func receive(amount: int = 1) -> int:
	# If there is enough space add amount
	if current + amount < max:
		current += amount
		return current

	# If there isn't enough space set to max
	current = max
	return current


func refill() -> void:
	if is_full:
		return

	await get_tree().create_timer(refill_time).timeout
	current += 1

	refill()


func deplete() -> void:
	if is_empty:
		return

	await get_tree().create_timer(deplete_time).timeout
	current -= 1

	deplete()


func _set_current(new_value) -> void:
	current = new_value
	if debug_entry:
		debug_entry.update_value(str(new_value))
	if new_value < max:
		is_full = false
	else:
		is_full = true
	if new_value == 0:
		is_empty = true
	else:
		is_empty = false

	current_changed.emit(current)


func _set_is_full(new_value) -> void:
	var previous_value := is_full
	is_full = new_value
	if previous_value == false and new_value == true:
		filled_up.emit()
	# If refill is true and it was full bevore start refilling
	if previous_value == true and new_value == false and refills:
		refill()
		print("start refill")


func _set_is_empty(new_value) -> void:
	var previous_value := is_empty
	is_empty = new_value
	if previous_value == false and new_value == true:
		emptied.emit()
	# If deplete is true and it was empty bevore start depleting
	if previous_value == true and new_value == false and depletes:
		deplete()
		print("start deplete")
