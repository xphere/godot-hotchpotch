extends Node

signal critical(message)
signal error(message)
signal warning(message)

"""
Check if the current value is OK, errors otherwise.
Useful when calling methods like `emit_signal`, `connect`...
"""
func check(value, message: String = "Invalid check") -> void:
	assert value == OK
	if value != OK:
		error(message)

"""
Logs an entry error as critical and emits the corresponding signal.
"""
func critical(description: String) -> void:
	printerr("CRITICAL ERROR! ", description)
	emit_signal("critical", description)

"""
Logs an entry error and emits the corresponding signal.
"""
func error(description: String) -> void:
	printerr("ERROR: ", description)
	emit_signal("error", description)

"""
Logs an entry error as warning and emits the corresponding signal.
"""
func warning(description: String) -> void:
	printerr("Warning: ", description)
	emit_signal("warning", description)

"""
Useful when you want to exit after a critical error.
"""
func quit_on_critical() -> void:
	connect("critical", self, "__do_quit")

func __do_quit(message) -> void:
	yield(get_tree(), "idle_frame")
	get_tree().quit()
