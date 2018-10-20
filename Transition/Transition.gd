extends CanvasItem

onready var player = $AnimationPlayer

func show() -> void:
	.show()
	player.play("FadeIn")
	yield(player, "animation_finished")


func hide() -> void:
	player.play("FadeOut")
	yield(player, "animation_finished")
	.hide()
