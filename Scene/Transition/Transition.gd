extends CanvasItem

onready var player = $AnimationPlayer

"""
Fade in content of the transition layer.
"""
func show() -> void:
	.show()
	player.play("FadeIn")
	yield(player, "animation_finished")

"""
Fade out content of the transition layer.
"""
func hide() -> void:
	player.play("FadeOut")
	yield(player, "animation_finished")
	.hide()
