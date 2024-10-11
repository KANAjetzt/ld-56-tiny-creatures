class_name UIDebugPanel
extends PanelContainer


@export var entry_scene: PackedScene

@onready var entries: VBoxContainer = %Entries


func add_entry(_info: String, _value: String) -> UIDebugPanelEntry:
	var new_entry: UIDebugPanelEntry = entry_scene.instantiate()
	entries.add_child(new_entry)
	new_entry.init(_info, _value)

	return new_entry
