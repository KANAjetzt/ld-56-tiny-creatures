class_name UIBook
extends PanelContainer


@export var unknown_icon: Texture

@onready var icon: TextureRect = %Icon
@onready var label_name: Label = %LabelName
@onready var info_text: RichTextLabel = %InfoText

var info_text_template := """
Happy Bees: {%BEE_COUNT%}
{%CREATURE_INFO%}
"""

var pages: Array[CreatureData] = []
var current_page_index := 0


func _ready() -> void:
	hide()

	for creature in Global.creatures:
		add_page(creature)

	Global.creature_discovered.connect(_on_creature_discovered)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_book"):
		if visible:
			hide()
		else:
			make_visible()


func make_visible() -> void:
	if pages[current_page_index].is_discovered:
		init_page(pages[current_page_index])
	else:
		init_preview_page()

	show()


func add_page(creature: CreatureData) -> void:
	pages.push_back(creature)


func init_page(creature: CreatureData) -> void:
	icon.texture = creature.icon
	label_name.text = creature.display_name
	info_text.text = info_text_template.format({
		"%BEE_COUNT%": Global.creature_count[creature.id] if Global.creature_count.has(creature.id) else 0,
		"%CREATURE_INFO%": creature.info_text
	})


func init_preview_page() -> void:
	icon.texture = unknown_icon
	label_name.text = "???"
	info_text.text = info_text_template.format({
		"%BEE_COUNT%": 0,
		"%CREATURE_INFO%": """
???
"""
	})


func _on_creature_discovered(creature: CreatureData) -> void:
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
