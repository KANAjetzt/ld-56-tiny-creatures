class_name UIFact
extends RichTextLabel

var task: TaskData
var index := 0


func init(_task: TaskData, _index: int) -> void:
	task = _task
	index = _index

	if task.is_completed:
		text = "● %s" % task.unlocks_fact[index]
	else:
		text = "● ???"

	task.completed.connect(_on_task_completed)


func _on_task_completed(task: TaskData) -> void:
	text = "● %s" % task.unlocks_fact[index]
