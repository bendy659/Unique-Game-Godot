extends Control

@onready var stream = $Stream
@onready var loadIcon = $LoadIcon

@onready var animator = $Animator
@onready var xdl = $XDL
@onready var godotIcon = $GodotIcon

var nTime: float = 0.0

## Main

func _ready() -> void:
	xdl.text = "%s \"Godot Engine\"" % Language.translate("startup.xdl")
	animator.play("RESET")
	
	stream.play()
	await Game.wait(0.1)
	
	stream.paused = true
	await Game.wait(1)
	
	loadIcon.visible = false
	stream.paused = false
	await Game.wait(6 + 1)
	
	animator.play("show")
	await Game.wait(3)
	
	LSM.loadScene("first_setup_settings_scene", false)

func _process(delta: float) -> void:
	nTime += delta
	
	loadIcon.rotation = nTime * 10
	godotIcon.rotation_degrees = sin(nTime * PI * 4) * 2.5
