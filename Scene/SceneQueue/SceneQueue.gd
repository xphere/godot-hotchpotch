extends Node

"""
This node would be notified when a transition is needed (fade in, fade out...)
"""
export var transition_path : NodePath = ""

onready var queue := $Queue
onready var current := $Current

"""
Runs given elements in queue one-by-one.
Can be nested into another queue or nodes with the `run()` method.
"""
func run() -> void:
	var next
	var transition = get_node(transition_path) if transition_path else null

	while queue.has_next_scene():
		_pause()

		next = yield(queue.next(), "completed")
		for child in current.get_children():
			child.queue_free()
		current.add_child(next)
		next.show()

		if transition:
			yield(transition.hide(), "completed")

		_unpause()

		if next.has_method("run"):
			yield(next.run(), "completed")
		else:
			yield(next, "tree_exited")

		if transition:
			yield(transition.show(), "completed")

"""
Pauses the whole tree.
Will be called just after transition is shown.
"""
func _pause() -> void:
	if is_inside_tree():
		get_tree().paused = true

"""
Unpauses the whole tree.
Will be called just after transition is hidden.
"""
func _unpause() -> void:
	if is_inside_tree():
		get_tree().paused = false
