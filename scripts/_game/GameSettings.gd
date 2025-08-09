extends Node

## General
var language = Prop.new("Language", 0)
var windowMode = Prop.new("Window mode", DisplayServer.WINDOW_MODE_WINDOWED)
var vSuyncMode = Prop.new("V-Sync mode", DisplayServer.VSYNC_ENABLED)
var maxFps = Prop.new("Max FPS", 24)
	
## Sounds
var soundGeneral = Prop.new("General", 25)
var soundMusic = Prop.new("General", 25)

signal onGameSettingsChanged

## Main

func _ready() -> void:
	onGameSettingsChanged.connect(_onGameSettingsChange)

func _onGameSettingsChange() -> void:
	pass

## Util's

class Prop:
	var name: String
	var value: Variant
	
	func _init(iname: String, ivalue: Variant) -> void:
		name = iname
		value = ivalue
