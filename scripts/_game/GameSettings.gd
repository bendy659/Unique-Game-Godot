extends Node

## General
var language = Prop.new("Language", 0)
var windowMode = Prop.new("Window mode", DisplayServer.WINDOW_MODE_WINDOWED)
var vSuyncMode = Prop.new("V-Sync mode", DisplayServer.VSYNC_ENABLED)
var maxFps = Prop.new("Max FPS", 24)
	
## Sounds
var soundMaster = PropSound.new("Master", 1)
var soundMusic = PropSound.new("Music", 1)

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

class PropSound extends Prop:
	var streams: Dictionary = {}
	
	func addStream(istream: Object, id: String, volume: float) -> void:
		streams[id] = {
			"stream": istream,
			"type": istream.get_class(),
			"volume": 1.0
		}
	
	func removeStream(id: String) -> void:
		streams.erase(id)
	
	func clearStreams() -> void:
		streams.clear()
	
	func playSound(localPath: String, streamId: String) -> void:
		var stream = streams[streamId]["stream"]
		var volume = streams[streamId]["volume"]
		var soundPath = load("res://sounds" + localPath + ".mp3")
		
		stream.volume_db = linear_to_db(volume)
		stream.stream = soundPath
		stream.play()
	
	func stopSound(streamId: String) -> void:
		var stream = streams[streamId]["stream"]
		
		stream.stop()
