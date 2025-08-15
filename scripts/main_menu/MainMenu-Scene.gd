extends Control

@onready var vienetce = $Vienetce

var aTime: float = 0.0

## Background
@onready var bg = $Background
@onready var bgLine = $Background/Line0

var bgLines: Dictionary = {}
var bgTexture = load("res://textures/main_menu/background.png")

func _ready() -> void:
	# Generate background lines
	var lineCopy = bgLine.duplicate()
	$Background.remove_child(bgLine)
	for i in range(14):
		var line = lineCopy.duplicate()
		var atlas = AtlasTexture.new()
		
		atlas.atlas = bgTexture
		atlas.region.size.y = 1296
		
		bgLines[i] = atlas
		
		line.texture = bgLines[i]
		line.position.x = lineCopy.position.x
		line.position.y = lineCopy.position.y + (64 * i)
		line.modulate = lerp(Color.RED, Color.YELLOW, float(i) / (14 - 1))
		
		bg.add_child(line)
	await get_tree().process_frame
	await Game.wait(1)

func _process(delta: float) -> void:
	aTime += delta
	
	for i in bgLines.keys():
		bgLines[i].region.position.y = aTime * (1 if i % 2 == 0 else -1) * 4
