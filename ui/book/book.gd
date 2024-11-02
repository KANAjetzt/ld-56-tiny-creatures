class_name UIBook
extends PanelContainer


@export var unknown_icon: Texture
@export var task_scene: PackedScene
@export var fact_scene: PackedScene

@onready var icon: TextureRect = %Icon
@onready var label_name: Label = %LabelName
@onready var info_text: RichTextLabel = %InfoText
@onready var tasks: VBoxContainer = %Tasks
@onready var facts: VBoxContainer = %Facts
@onready var button_right: Button = %ButtonRight

var info_text_template := """
Happy Bees: {%BEE_COUNT%}

{%CREATURE_INFO%}
"""

var pages: Array[CreatureGlobalData] = []
var current_page_index := 0


func _ready() -> void:
	hide()

	for creature in Global.creatures:
		add_page(creature)

	Global.creature_discovered.connect(_on_creature_discovered)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_book") or Input.is_action_just_pressed("close"):
		if visible:
			make_invisble()
		else:
			make_visible()


func make_visible() -> void:
	if pages[current_page_index].is_discovered:
		init_page(pages[current_page_index])
	else:
		init_preview_page()

	show()
	Global.is_book_open = true
	button_right.grab_focus()


func make_invisble() -> void:
	hide()
	Global.is_book_open = false


func add_page(creature: CreatureGlobalData) -> void:
	pages.push_back(creature)


func init_page(creature: CreatureGlobalData) -> void:
	icon.texture = creature.icon
	label_name.text = creature.display_name
	info_text.text = info_text_template.format({
		"%BEE_COUNT%": Global.creature_count[creature.id] if Global.creature_count.has(creature.id) else 0,
		"%CREATURE_INFO%": creature.info_text
	})

	Utils.free_children(tasks)
	Utils.free_children(facts)

	if creature.tasks:
		for task in creature.tasks.get_all_tasks():
			var new_task: UITask = task_scene.instantiate()
			tasks.add_child(new_task)
			new_task.init(task)

			for i in task.unlocks_fact.size():
				var fact_text := task.unlocks_fact[i]
				var new_fact: UIFact = fact_scene.instantiate()
				facts.add_child(new_fact)
				new_fact.init(task, i)

		var fact_source := Label.new()
		facts.add_child(fact_source)
		fact_source.text = creature.fact_source
		fact_source.add_theme_font_size_override(&"font_size", 12)


func init_preview_page() -> void:
	icon.texture = unknown_icon
	label_name.text = "???"
	info_text.text = info_text_template.format({
		"%BEE_COUNT%": 0,
		"%CREATURE_INFO%": """
???
"""
	})

	Utils.free_children(tasks)
	Utils.free_children(facts)


func _on_creature_discovered(creature: CreatureGlobalData) -> void:
	Global.creatures[Global.creatures.find(creature)].is_discovered = true
	if visible:
		init_page(pages[current_page_index])


func _on_button_left_pressed() -> void:
	current_page_index -= 1
	if  current_page_index < 0:
		current_page_index = pages.size() - 1

	var creature_data := pages[current_page_index]

	if creature_data.is_discovered:
		init_page(pages[current_page_index])
	else:
		init_preview_page()


func _on_button_right_pressed() -> void:
	current_page_index += 1
	if  current_page_index > pages.size() - 1:
		current_page_index = 0

	var creature_data := pages[current_page_index]

	if creature_data.is_discovered:
		init_page(pages[current_page_index])
	else:
		init_preview_page()
