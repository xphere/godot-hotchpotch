extends Node

signal load_finished(path)
signal load_stage(path, stage, total)

var loader : Thread
var mutex : Mutex
var ready : Semaphore
var resources = {}
var queued = []
var running = true


func _init() -> void:
	start()


func queue(path: String, in_front: bool = false) -> void:
	mutex.lock()
	if not _has_resource(path) or not _is_loaded(path):
		_queue_resource(path, in_front)
	mutex.unlock()


func cancel(path: String) -> void:
	mutex.lock()
	if path in resources:
		queued.erase(resources[path])
		resources.erase(path)
	mutex.unlock()


func wait(path: String) -> void:
	yield(get_tree(), "idle_frame")
	mutex.lock()
	while not path in resources:
		mutex.unlock()
		yield(self, "load_finished")
		mutex.lock()
	mutex.unlock()


func resource(path: String) -> Resource:
	if not path in resources:
		mutex.lock()
		if not _is_loaded(path):
			ErrorHandler.error("Resource '%s' is not loaded yet, call `wait(path) before." % path)
		mutex.unlock()

	return resources[path] if path in resources else null


func start() -> void:
	assert not loader
	mutex = Mutex.new()
	ready = Semaphore.new()
	loader = Thread.new()
	ErrorHandler.check(loader.start(self, "_background_loader"))


func stop() -> void:
	assert loader
	mutex.lock()
	running = false
	queued = []
	resources = {}
	mutex.unlock()
	ErrorHandler.check(ready.post())
	loader.wait_to_finish()
	mutex = null
	ready = null
	loader = null


func _background_loader(_data) -> void:
	var is_running = true

	while is_running:
		ErrorHandler.check(ready.wait())
		mutex.lock()
		while not queued.empty():
			var loader = queued[0]
			mutex.unlock()
			var is_ready = _poll_resource(loader)
			mutex.lock()
			if is_ready:
				queued.erase(loader)
		is_running = running
		mutex.unlock()


func _poll_resource(loader: ResourceInteractiveLoader) -> bool:
	var result = loader.poll()
	var path = loader.get_meta("path")
	var stage_count = loader.get_stage_count()
	var current_stage = loader.get_stage() if result == OK else stage_count

	emit_signal("load_stage", path, current_stage, stage_count)
	if result == OK:
		return false

	if not path in resources:
		_set_resource(path, loader.get_resource())

	return true


func _has_resource(path: String) -> bool:
	return path in resources


func _is_loaded(path: String) -> bool:
	if ResourceLoader.exists(path):
		_set_resource(path, ResourceLoader.load(path))
		return true
	return false


func _set_resource(path: String, resource: Resource) -> void:
	resources[path] = resource
	emit_signal("load_finished", path)


func _queue_resource(path: String, in_front: bool = false) -> void:
	var loader = ResourceLoader.load_interactive(path)
	loader.set_meta("path", path)
	if in_front:
		queued.push_front(loader)
	else:
		queued.push_back(loader)
	ErrorHandler.check(ready.post())
