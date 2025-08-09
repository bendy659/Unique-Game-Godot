extends Node

const musics: Array[Dictionary] = [
	{
		"name": "Choose joy",
		"id": "choose_joy",
		"bpm": { 0: 75 },
		"author": null,
		"color": [0, 1, 0]
	},
	{
		"name": "Exploration chiptune RPG adventure",
		"id": "exploration_chiptune_rpg_adventure",
		"bpm": { 0: 75 },
		"author": null,
		"color": [1, 0, 0]
	},
	{
		"name": "Game mode On",
		"id": "game_mode_on",
		"bpm": { 0: 130 },
		"author": null,
		"color": [1, 0, 1]
	}
]

var playing: int = 1
var currentTime: int = -1
var currentBpm: int = -1
var totalBpm: int = -1
var totalBeats: int = -1

signal onMusicStarted(id: String)
signal onMusicPlaying(id: String)
signal onMusicEnded(id: String)
signal onMusicBeat

## Main

func _ready() -> void:
	onMusicStarted.connect(_onMusicStarted)
	onMusicPlaying.connect(_onMusicPlaying)
	onMusicEnded.connect(_onMusicEnded)
	onMusicBeat.connect(_onMusicBeat)

func _process(delta: float) -> void:
	if playing != -1:
		onMusicPlaying.emit(playing, delta)

## Util's

func playMusic(id: int, notification: bool = true) -> void:
	pass

func _onMusicStarted(id: int) -> void:
	playing = id

func _onMusicPlaying(id: int, delta: float) -> void:
	currentTime += delta
	
	# Calc bpm
	var intervalBpm = 60 / currentBpm
	
	if currentTime >= intervalBpm:
		onMusicBeat.emit()

func _onMusicEnded(id: int) -> void:
	playing = -1 if id == playing else playing
	currentTime = -1
	totalBpm = -1
	totalBeats = -1

func _onMusicBeat() -> void:
	totalBeats += 1
