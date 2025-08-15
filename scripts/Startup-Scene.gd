extends Control

@onready var stream = $Stream
@onready var loadIcon = $LoadIcon

@onready var animator = $Animator
@onready var xdl = $XDL
@onready var godotIcon = $GodotIcon

var nTime: float = 0.0

## Main

func _ready() -> void:
	Game.updateCanvas(self)
	
	xdl.text = "%s \"Godot Engine\"" % Language.translate("startup.xdl")
	animator.play("RESET")
	
	stream.play()
	await Game.wait(0.1)
	
	stream.paused = true
	await Game.wait(1)
	
	loadIcon.visible = false
	stream.paused = false
	AchivementManager.getAchi("example").unlock()
	await Game.wait(6 + 1)
	
	AchivementManager.getAchi("example").lock()
	animator.play("show")
	await Game.wait(3)
	
	LSM.loadScene("FirstSetupSettings-Scene", false)

func _process(delta: float) -> void:
	nTime += delta
	
	loadIcon.rotation = nTime * 10
	godotIcon.rotation_degrees = sin(nTime * PI * 4) * 2.5
