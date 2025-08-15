extends Control

@onready var SAD_FACE = $SAD_FACE
@onready var scrollContainer = $Panel/ScrollContainer
@onready var logs = $Panel/ScrollContainer/VBoxContainer

## Main

var exampleLabel = null
var copyLabel = null # copy
var logId = -1

func _ready() -> void:
	exampleLabel = get_node("Panel/ScrollContainer/VBoxContainer/ExampleLabel")
	copyLabel = exampleLabel.duplicate()
	
	updateLogs()
	
	if exampleLabel:
		logs.remove_child(exampleLabel)

func _input(event: InputEvent) -> void:
	match event.as_text():
		"Enter": # Full restart game
			Logger.info("Restarting game...")
			updateLogs()
			await Game.wait(1)
			
			LSM.loadScene("startup_scene")
		"Escape": # Close game
			Logger.info("Exit from game...")
			updateLogs()
			await Game.wait(1)
			
			get_tree().quit()
		"0": # Open test-polygone
			Logger.info("Open test-polygone...")
			updateLogs()
			await Game.wait(1)
			
			LSM.loadScene("test_polygone")

## Util's

func updateLogs() -> void:
	# Clear labels
	for part in logs.get_children():
		logs.remove_child(part)
	
	# Add label from logs
	for part in Logger.logList:
		logId += 1
		
		var xdLabel = copyLabel.duplicate()
		xdLabel.name = "LOG_%s" % logId
		xdLabel.text = "%s %s" % [part["level"]["level"], part["label"]]
		xdLabel.modulate = part["level"]["color"]
		logs.add_child(xdLabel)
	
	# Scrolling to down
	var vbar = scrollContainer.get_v_scroll_bar()
	
