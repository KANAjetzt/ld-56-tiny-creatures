extends Node2D


@export var spawner_scene: PackedScene


@onready var placeable_preview: UIPlaceablePreview = %PlaceablePreview
@onready var hud: UIHUD = %Hud
@onready var plants: Node = %Plants
@onready var placeables: Node = %Placeables
@onready var constructed: Node = %Constructed
@onready var bees: Node = %Bees
@onready var book: UIBook = %Book
@onready var spawners_component: SpawnersComponent = %SpawnersComponent

var first_spawned := false


func _ready() -> void:
	Global.main_ref = self
	Global.check_creature_criteria()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("place") and not hud.fly_in.is_in:
		place_placeable()
	if Input.is_action_just_pressed("deselect"):
		Global.currently_selected_placeable = null
		placeable_preview.remove_preview()


func place_placeable() -> void:
	if not Global.currently_selected_placeable:
		print("INFO: No placeable selected.")
		return
	if not Global.currently_selected_placeable.scene_path:
		assert(false, "ERROR: No scene_path in placeable_data.")
		return
	if Global.currently_selected_placeable.amount_current == 0:
		print("INFO: Placeable amount is 0.")

		Global.currently_selected_placeable = null
		placeable_preview.remove_preview()
		return

	var new_placeable: Placeable = load(Global.currently_selected_placeable.scene_path).instantiate()
	if Global.currently_selected_placeable.is_plant:
		plants.add_child(new_placeable)
	else:
		placeables.add_child(new_placeable)
	new_placeable.global_position = get_global_mouse_position()
	new_placeable.place_sfx.play()

	Global.currently_selected_placeable.amount_current -= 1

	if Global.currently_selected_placeable.is_plant:
		if not Global.currently_placed_plants.has(Global.currently_selected_placeable.id):
			Global.currently_placed_plants[Global.currently_selected_placeable.id] = 1
		else:
			Global.currently_placed_plants[Global.currently_selected_placeable.id] += 1

	Global.check_creature_criteria()


func _on_hud_placeable_selected(data: PlaceableGlobalData) -> void:
	placeable_preview.set_preview(data.icon)


func _on_hud_button_book_pressed() -> void:
	if not book.visible:
		book.make_visible()
	else:
		book.make_invisble()


func _on_spawners_component_spawned(creature: Node2D, creature_data: CreatureGlobalData) -> void:
	if not first_spawned:
		Global.current_focused_creature = creature
		first_spawned = true
	else:
		spawners_component.spawned.disconnect(_on_spawners_component_spawned)
