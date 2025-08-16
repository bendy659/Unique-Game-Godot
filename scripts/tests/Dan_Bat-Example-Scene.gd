extends Control

@onready var flagPart = $Root/Flag_0

var animator: AnimationHandler._Animator
var aTime: float = 0.0

var flagParts: Array[ColorRect] = []

func _ready():
	flagParts.append(flagPart)
	
	const colors = [Color.RED, Color.ORANGE, Color.YELLOW, Color.GREEN, Color.BLUE, Color.VIOLET]
	for i in range(0, colors.size()):
		var part = flagPart.duplicate()
		
		part.position += Vector2(0, 24 * clamp(i, 1, colors.size()))
		part.size.y = 24
		part.color = colors[i]
		
		flagParts.append(part)
		$Root.add_child(part)

func _process(delta: float):
	aTime += delta
	
	$Group_0/ColorRect2.rotation_degrees = aTime * 16
	
	$Root.rotation = cos(aTime * PI * 2 ) / 64 + 0.05
	
	for part in flagParts:
		part.rotation = sin(aTime * PI * 2) / 16
		part.position.y += (-sin(aTime * PI * 2) / 16)
