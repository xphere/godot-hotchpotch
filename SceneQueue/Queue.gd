extends Node

func has_next_scene() -> bool:
	return get_child_count() > 0


func next() -> Node:
	var next = get_child(0)

	if next is InstancePlaceholder:
		var path = next.get_instance_path()
		BackgroundLoader.queue(path)
		yield(BackgroundLoader.wait(path), "completed")
		next.replace_by_instance(BackgroundLoader.resource(path))
		next = get_child(0)
	else:
		yield(get_tree(), "idle_frame")

	call_deferred("remove_child", next)
	return next


func _ready() -> void:
	_make_sure_children_are_hiden()


func _make_sure_children_are_hiden():
	for child in get_children():
		if child.has_method("hide"):
			child.hide()
