extends Node

## General
var language = Prop.new("Language", 0)
var windowMode = Prop.new("Window mode", DisplayServer.WINDOW_MODE_WINDOWED)
var vSuyncMode = Prop.new("V-Sync mode", DisplayServer.VSYNC_ENABLED)
var maxFps = Prop.new("Max FPS", 24)
	
## Sounds
var soundMaster = PropSound.new("Master", 1)
var soundMusic = PropSound.new("Music", 1, soundMaster)
var soundEnv = PropSound.new("Env", 1, soundMaster)
var soundUI = PropSound.new("UI", 1, soundMaster)

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

	func setValue(ivalue: Variant) -> void:
		value = ivalue

class PropSound:
	var audioBusIndex: int
	var volume: float
	var parent: PropSound
	var streams: Array[AudioStream]
	
	func _init(iaudioBus: StringName, ivolume: float = 1.0, iparent: PropSound = null) -> void:
		audioBusIndex = AudioServer.get_bus_index(iaudioBus)
		AudioServer.set_bus_volume_linear(audioBusIndex, ivolume)
		volume = AudioServer.get_bus_volume_linear(audioBusIndex)
	
	func setVolume(ivolume: float) -> void:
		if parent:
			AudioServer.set_bus_volume_linear(audioBusIndex, ivolume * parent.volume)
			volume = ivolume * parent.volume
		else:
			AudioServer.set_bus_volume_linear(audioBusIndex, volume)
			volume = ivolume
	
	func updateVolume() -> void:
		if parent:
			AudioServer.set_bus_volume_linear(audioBusIndex, volume * parent.volume)
		else:
			AudioServer.set_bus_volume_linear(audioBusIndex, volume)
	
	func addStream(istream: Object) -> void:
		Logger.info("Stream %s added to %s" % [
			istream, AudioServer.get_bus_name(audioBusIndex)
		])
		streams.append(istream)
		
	
	func removeStream(istream: Object) -> void:
		for i in range(streams.size()):
			if streams[i] == istream:
				Logger.info("Stream %s has removed from %s" % [
					streams[i], AudioServer.get_bus_name(audioBusIndex)
				])
				streams.remove_at(i)
	
	func playSound(localPath: String) -> void:
		var soundPath = load("res://sounds/" + localPath + ".mp3")
		var apply = false
		
		for stream in streams:
			if !stream.playing:
				apply = true
				stream.stream = soundPath
				stream.play()
		if !apply:
			Logger.warn("All streams from %s is playing. Not found empty!")
