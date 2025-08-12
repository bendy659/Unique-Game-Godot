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

func updateCanvas(overrideCanvas: CanvasLayer = null) -> void:
	canvas = overrideCanvas if overrideCanvas else _findCanvas(get_tree().root)

func _findCanvas(parent: Node) -> CanvasLayer:
	var root = get_tree().root
	
	if root == null:
		root = parent

	for child in parent.get_children():
		if child is CanvasLayer:
			canvas_found.emit()
			return child
		
		var found = _findCanvas(child)
		if found != null:
			return found
	
	if parent == root:
		var nCanvas = CanvasLayer.new()
		parent.add_child(nCanvas)
		canvas_found.emit()
		return nCanvas
	
	return null
