# Hotchpotch for Godot 3.1

This repository includes some configurable elements that can be reused in multiple Godot projects.

If you find something missing or a bug, or just want to discuss something, please create an issue.

## List of elements

### BackgroundLoader
Singleton helper to load resources on the background and notify when ready.
Depends on `ErrorHandler`.

### ErrorHandler
Singleton helper to log critical errors, simple errors and warnings.
You can connect to the corresponding signals to react when something goes wrong.

### Overlay
A simple CanvasLayer configured to be on top of everything and not paused.
Works well with `SceneQueue` and `Transition`.

### Random
Create a sequence of random numbers and adds helpers to get floats, integers and ranges.

Usage:
```gdscript
var prng_seed = randi() # use any value to seed the prng
var prng = Random.new(prng_seed)
var random_value = prng.int_in_range(10, 20)
```

### SceneQueue
Helps creating a queue of scenes which will run one after another.
You only need to add elements to the `Queue` node (as a placeholder if you like it better).
Executes a `run()` method in each node if it exists, or waits until node is removed.
Also notifies a configurable node to show/hide during the scene load. (works well with `Transition`)
Depends on `BackgroundLoader`.

### Transition
Runs an animation fade-in/fade-out based on a given grayscale mask.
Based on GDquest transition.
Can show any content inside thanks to the viewport.

## Example

1. Inherit a new node from `SceneQueue`.
2. Drag an `Overlay` into the root node.
3. Drag a `Transition` into the `Overlay` node.
4. Create your loading scene and drag it into `Overlay/Transition/Viewport`.
5. Create some scenes with a `run()->void` method. Make it `yield` until something is done. Like:
```gdscript
func run() -> void:
	$Animation.play("animation")
	yield($Animation, "animation_finished")
```
6. Drag each scene into the Queue. Mark them with "As placeholder".
