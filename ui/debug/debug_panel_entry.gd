class_name UIDebugPanelEntry
extends HBoxContainer


@onready var info: Label = %Info
@onready var value: Label = %Value


func init(_info: String, _value: String) -> void:
	info.text = _info
	value.text = _value


func update_info(_info: String) -> void:
	info.text = _info


func update_value(_value: String) -> void:
	value.text = _value
