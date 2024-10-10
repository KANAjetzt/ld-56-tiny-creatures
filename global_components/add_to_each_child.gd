class_name AddToEachChildComponent
extends Node


@export var base_node: Node
@export var component_to_add: Node
## Can be used to set a prop that references the added prop.
## The prop is set on the parent of the added component.
## Thats each child of the base_node.
@export var prop: String


func _ready() -> void:
	for child in base_node.get_children():
		var new_component := component_to_add.duplicate()
		child.add_child(new_component)

		if not prop.is_empty():
			child[prop] = new_component
