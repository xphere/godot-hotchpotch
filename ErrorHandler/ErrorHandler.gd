extends Node

signal critical(message)
signal error(message)
signal warning(message)

func check(value, message: String = "Invalid check") -> void:
	assert value == OK
	if value != OK:
		error(message)

func critical(description: String) -> void:
	printerr("CRITICAL ERROR! ", description)
	emit_signal("critical", description)

func error(description: String) -> void:
	printerr("ERROR: ", description)
	emit_signal("error", description)

func warning(description: String) -> void:
	printerr("Warning: ", description)
	emit_signal("warning", description)

func quit_on_critical() -> void:
	connect("critical", self, "__do_quit")

func __do_quit(message) -> void:
	yield(get_tree(), "idle_frame")
	get_tree().quit()
