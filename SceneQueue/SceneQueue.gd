extends Node

onready var queue = $Queue
onready var current: Node = $Current
onready var transition_player: AnimationPlayer = $Overlay/Transition/AnimationPlayer


func run() -> void:
	var next

	while queue.has_next_scene():
		pause()

		next = yield(queue.next(), "completed")
		for child in current.get_children():
			child.queue_free()
		current.add_child(next)
		next.show()

		transition_player.play("FadeOut")
		yield(transition_player, "animation_finished")

		unpause()

		if next.has_method("run"):
			yield(next.run(), "completed")
		else:
			yield(next, "tree_exited")

		transition_player.play("FadeIn")
		yield(transition_player, "animation_finished")


func pause() -> void:
	if is_inside_tree():
		get_tree().paused = true


func unpause() -> void:
	if is_inside_tree():
		get_tree().paused = false
