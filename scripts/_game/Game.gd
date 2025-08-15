extends Node

var canvas: CanvasLayer

signal canvas_found

## Main

func _input(event: InputEvent) -> void:
	var crashGame = Input.is_action_just_pressed("CrashGame")
	
	if crashGame:
		Logger.err("==== Game intentional crashed! ====")

## Util's

func wait(sec: float) -> void:
	await get_tree().create_timer(sec).timeout

func updateCanvas(parent: Node, overrideCanvas: CanvasLayer = null) -> void:
	canvas = overrideCanvas if overrideCanvas else _findCanvas(parent)
	canvas_found.emit()

func _findCanvas(parent: Node) -> CanvasLayer:
	for child in parent.get_children():
		if child is CanvasLayer:
			return child
		
		var found = _findCanvas(child)
		if found != null:
			return found
	
	var nCanvas = CanvasLayer.new()
	parent.add_child(nCanvas)
	return nCanvas
	
	return null
