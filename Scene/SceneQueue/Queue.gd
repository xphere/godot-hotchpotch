extends Node

"""
Queues loading of all elements in the queue.
"""
export var do_preload : bool = false

"""
Check whether there's a queued scene before the current one.
"""
func has_next_scene() -> bool:
	return get_child_count() > 0

"""
Get the next scene in the queue.
Removes it from queue in order to `add_child(result)` to another node.
"""
func next() -> Node:
	yield(get_tree(), "idle_frame")

	var next := get_child(0)

	# Special treatment to InstancePlaceholder
	if next is InstancePlaceholder:
		var path = next.get_instance_path()
		BackgroundLoader.queue(path)
		yield(BackgroundLoader.wait(path), "completed")
		next.replace_by_instance(BackgroundLoader.resource(path))
		next.queue_free()
		next = get_child(0)

	remove_child(next)

	return next


func _ready() -> void:
	_make_sure_children_are_hidden()
	if do_preload:
		_queue_children_scenes()


func _make_sure_children_are_hidden():
	for child in get_children():
		if child.has_method("hide"):
			child.hide()


func _queue_children_scenes() -> void:
	for child in get_children():
		if child is InstancePlaceholder:
			var path = child.get_instance_path()
			BackgroundLoader.queue(path)
