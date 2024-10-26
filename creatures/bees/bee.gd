class_name BeeComponent
extends Node2D


signal found_habitat(bee: BeeComponent)
signal entered_habitat(bee: BeeComponent)
signal collected_pollen(bee: BeeComponent)
signal delivered_pollen(bee: BeeComponent)

@export var data: CreatureData
@export var movement: MovementComponent
@export var attractee: AttracteeComponent
@export var pollen_container: PollenContainerComponent
@export var fade: FadeComponent
@export var shake: ShakeComponent
@export var sound: BeeSoundComponent
@export var digging: DiggingComponent
@export var search_scale := 10
@export var search_distance_min := 100
@export var max_distance_from_habitat := 1000
@export var max_search_time := 60.0
@export var debug_panel: UIDebugPanel

var memory_success: Array[PlaceableData] = []
var memory_no_success: PlaceableData
var no_pollen_counter := 0
var is_collecting := false
var timer_max_search_time := Timer.new()

var debug_entry: UIDebugPanelEntry
var debug_entry_name: UIDebugPanelEntry


func _ready() -> void:
	if debug_panel:
		debug_entry_name = debug_panel.add_entry("name:", name)
		debug_entry = debug_panel.add_entry("current_local_data:", str(data.current_local_data))

	search()

	attractee.inside_attractor_area.connect(_on_inside_attractor_area)
	movement.target_reached.connect(_on_target_reached)
	timer_max_search_time.timeout.connect(_on_timer_max_search_time_timeout)
	data.current_local_data_changed.connect(_on_data_current_local_data_changed)
	if digging:
		digging.finished.connect(_on_digging_finished)


func _process(delta: float) -> void:
	if data.current_habitat:
		if global_position.distance_to(data.current_habitat_position.global_position) > max_distance_from_habitat:
			data.current_local = data.current_habitat
			travel(data.current_habitat_position.global_position)


## Search the next attractor
func search() -> void:
	data.current_local_data = null

	var random_direction := Vector2(randf() * 2.0 - 1.0, randf() * 2.0 - 1.0)
	var random_distance := movement.min_distance_to_target + search_distance_min + randf() * search_scale
	var new_target := movement.parent.global_position + random_direction * random_distance

	movement.target = new_target


# If on a plant - stay there until pollen container is filled or plant container is empty
func collect(plant_creature_positions: CreaturePositionsComponent) -> void:
	is_collecting = true
	# pick random position to occupy
	var plant_creature_position_occupied := plant_creature_positions.occupy_position()

	if plant_creature_position_occupied == null:
		memory_no_success = data.current_local_data
		is_collecting = false
		search()
		return

	# travel to the occupied position
	travel(plant_creature_position_occupied.global_position)

	# BUG: Something is going wrong here
	# BUG: In _on_target_reached is the timer for the action on the target
	# BUG: That timers gets skipped here
	await movement.target_reached
	# TODO: Quick fix - sometimes after awaiting the current_local can be reset to null some how
	if data.current_local_data == null:
		print("INFO: Quick fix for `current_local_data == null` is used.")
		is_collecting = false
		search()
		return

	# Check for pollen
	await get_tree().create_timer(data.current_local_data.wait_time * 0.5).timeout
	if data.current_local_data == null:
		print("INFO: Quick fix for `current_local_data == null` is used.")
		is_collecting = false
		search()
		return

	# Retrieve pollen if available
	var local_pollen_container := plant_creature_position_occupied.pollen_container as  PollenContainerComponent
	var given_pollen_count := local_pollen_container.give()
	# If there is pollen receive it
	if not given_pollen_count == -1:
		no_pollen_counter = 0
		# Receive pollen
		shake.is_active = false
		sound.fade_out()
		await get_tree().create_timer(data.current_local_data.wait_time * 0.5).timeout
		if data.current_local_data == null:
			print("INFO: Quick fix for `current_local_data == null` is used.")
			is_collecting = false
			search()
			return
		shake.is_active = true
		sound.fade_in()
		var receiver_pollen_count := pollen_container.receive(given_pollen_count)
		collected_pollen.emit(self)
	else:
		no_pollen_counter += 1

	# Free the occupied space
	plant_creature_position_occupied.clear()

	if pollen_container.is_full:
		is_collecting = false
		# Start traveling to habitat
		data.current_local_data = data.current_habitat.data
		travel(data.current_habitat_position.global_position)
	elif no_pollen_counter >= 3:
		is_collecting = false
		memory_no_success = data.current_local_data
		search()
	else:
		var random_direction := Vector2(randf() * 2.0 - 1.0, randf() * 2.0 - 1.0)
		var random_distance := randf() * 20 + 5
		var new_target := movement.parent.global_position + random_direction * random_distance

		movement.target = new_target

		await movement.target_reached
		await get_tree().create_timer(0.3 + randf() * 0.8).timeout

		collect(plant_creature_positions)


## Travel to a set location
func travel(target: Vector2) -> void:
	movement.target = target


func _on_target_reached() -> void:
	if digging and digging.is_digging:
		return
	if data.current_local_data == null:
		search()
	elif data.current_local_data and not is_collecting:
		if data.current_local_data.is_habitat:
			# Fade out bee
			fade.fade_out()
			sound.fade_out()
			# Drop pollen
			# TODO: Maybe do something if the pollen container is full?
			var pollen_count := pollen_container.give_all()
			data.current_habitat.pollen_container.receive(pollen_count)
			if pollen_count > 0:
				delivered_pollen.emit(self)
		# Wait until the action at the local is done
		await get_tree().create_timer(data.current_local_data.wait_time).timeout
		# TODO: Quick fix - sometimes after awaiting the current_local can be reset to null some how
		if data.current_local_data == null:
			print("INFO: Quick fix for `current_local_data == null` is used.")
			search()
			return
		# If at habitat
		if data.current_local_data.is_habitat:
			# Fade in bee
			fade.fade_in()
			sound.fade_in()
			await fade.fade_in_finished
			# Start searching for plants
			search()


func _on_inside_attractor_area(area: AttractorArea) -> void:
	# Check if searching for habitat
	if data.current_habitat == null:
		# Check if valid habitat
		if area.ref.habitat and area.ref.habitat.data in data.habitats:
			# Occupy position if available
			if not area.ref.creature_positions.all_occupied:
				data.current_habitat_position = area.ref.creature_positions.occupy_position()
				data.current_habitat = area.ref.habitat
				data.current_local_data = area.ref.habitat.data
				found_habitat.emit(self)
				travel(data.current_habitat_position.global_position)
	elif area.ref.plant:
		# Check memory
		if area.ref.plant.data == memory_no_success:
			search()
		elif not area.ref.creature_positions.all_occupied:
			data.current_local_data = area.ref.plant.data
			collect(area.ref.creature_positions)


func _on_timer_max_search_time_timeout() -> void:
	data.current_local = data.current_habitat
	travel(data.current_habitat_position.global_position)


func _on_data_current_local_data_changed(_data: PlaceableData) -> void:
	if debug_entry:
		if _data == null:
			debug_entry.update_value("null")
		else:
			debug_entry.update_value(_data.id)


func _on_digging_finished(_spawn_habitat_callable: Callable) ->  void:
	search()
