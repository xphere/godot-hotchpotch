extends Node

export var transition_path : NodePath = ""

onready var queue := $Queue
onready var current := $Current


func run() -> void:
	var next
	var transition = get_node(transition_path) if transition_path else null

	while queue.has_next_scene():
		pause()

		next = yield(queue.next(), "completed")
		for child in current.get_children():
			child.queue_free()
		current.add_child(next)
		next.show()

		if transition:
			yield(transition.hide(), "completed")

		unpause()

		if next.has_method("run"):
			yield(next.run(), "completed")
		else:
			yield(next, "tree_exited")

		if transition:
			yield(transition.show(), "completed")


func pause() -> void:
	if is_inside_tree():
		get_tree().paused = true


func unpause() -> void:
	if is_inside_tree():
		get_tree().paused = false
