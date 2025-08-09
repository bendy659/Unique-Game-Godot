extends Control

@onready var panel = $NowPlayingPanel
@onready var musicDisc = $MusicDisc
@onready var musicInfo = $NowPlayingPanel/Info

var cMusicPlaying: Dictionary = MusicManager.musics[MusicManager.playing]

var animator = AnimationHelper.Animator.new()

var sizeX: float
var sX: float
var eX: float
var wait: float

var nowPlaying: String
var author: String
var color: Color

## Main

func _ready() -> void:
	AnimationHelper.eventHandler.connect(onCallEventMusicManager)
	
	setup()

func _process(delta: float) -> void:
	var keys = animator.update(delta)
	
	panel.position.x = keys[0]
	musicDisc.position.x = keys[1]
	
	musicDisc.rotation_degrees += delta * 45

func setup() -> void:
	var authorZ = cMusicPlaying["author"]
	
	nowPlaying = cMusicPlaying["name"]
	author = authorZ if authorZ else "Unknown"
	musicInfo.text = "Now playing: %s\nAuthor: %s" % [nowPlaying, author]
	color = Color(
		cMusicPlaying["color"][0],
		cMusicPlaying["color"][1],
		cMusicPlaying["color"][2]
	)
	sX = 1280 + 8
	
	for chr in "Now playing: %s" % nowPlaying:
		eX += 7.25
		sizeX += 7.25
		wait += 0.1
	
	eX = 1280 - eX - 8
	sizeX = 8 + sizeX + 8
	
	panel.position.x = sX
	panel.size.x = sizeX
	panel.get_theme_stylebox("panel").border_color = color
	musicDisc.modulate = color
	
	animator.timeline([
		[
			AnimationHelper.Keyframe.new(0, sX, 0.25, &"TEST_IN"),
			AnimationHelper.Keyframe.new(1, eX),
			AnimationHelper.Keyframe.new(1 + wait, eX, 4.0, &"TEST_OUT"),
			AnimationHelper.Keyframe.new(1 + wait + 1,  sX)
		],
		[
			AnimationHelper.Keyframe.new(0, 1280 + 64 * 4, 0.125),
			AnimationHelper.Keyframe.new(1, 1280 - 64 * 2),
			AnimationHelper.Keyframe.new(1 + wait, 1280 - 64 * 2, 6.0),
			AnimationHelper.Keyframe.new(1 + wait + 1, 1280 + 64 * 4)
		]
	])
	animator.play()

func onCallEventMusicManager(callEvent: StringName) -> void:
	match callEvent:
		&"TEST_IN":
			print("TEST_IN")
		&"TEST_OUT":
			print("TEST_OUT")
