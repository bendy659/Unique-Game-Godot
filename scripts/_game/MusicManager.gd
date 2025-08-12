extends Node

var chooseJoy = MusicInfo.new(
	"Choose joy",
	null,
	"choose_joy",
	Color(0, 1, 0),
	{ 0: 75 }
)
var explorationChiptuneRPGAdventure = MusicInfo.new(
	"Exploration chiptune RPG adventure",
	null,
	"exploration_chiptune_rpg_adventure",
	Color(1, 0, 0),
	{ 0: 75 }
)
var gameModeOn = MusicInfo.new(
	"Game mode On",
	null,
	"game_mode_on",
	Color(1, 0, 1),
	{ 0: 130 }
)
var oiia_oiia = MusicInfo.new(
	"OIIA OIIA",
	"W&W",
	"w_w_oiia_oiia",
	Color(1, 1, 0),
	{
		0: 37.5,
		14.45: 400,
		27.30: 33,
		30.25: 75,
		32: 400,
		33.5: 130
	}
)

var musics: Dictionary = {}

var playing: int = -1
var currentTime: int = -1
var currentBpm: int = -1
var totalBpm: int = -1
var totalBeats: int = -1

signal nowPlaying(id: StringName)
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
	
	musics["mainMenu"] = [
		chooseJoy,
		explorationChiptuneRPGAdventure,
		gameModeOn
	]

func _process(delta: float) -> void:
	if playing != -1:
		onMusicPlaying.emit(playing, delta)

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


## Util's

class MusicInfo:
	var name: String
	var author: String
	var id: String
	var bpm: Dictionary
	var color: Color
	
	func _init(
		iname: String,
		iauthor: Variant,
		iid: String,
		icolor: Color,
		ibpm: Dictionary
	) -> void:
		name = iname
		author = iauthor if iauthor else "-"
		id = iid
		color = icolor
		bpm = ibpm

func playMusic(id: int, notification: bool = true) -> void:
	var selected = musics[id]
	
	GameSettings.soundMusic.playSound("music/" + musics[id].id)
