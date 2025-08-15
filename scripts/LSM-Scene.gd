extends Control

@onready var loadIcon = $LoadIcon
@onready var funFactLabel = $FunFactsLabel
@onready var progress = $Progress
@onready var pressAnyButton = $PressAnyButton
@onready var loadBar = $LoadBar

var nTime: float = 0.0
var loadComplete: bool = false
var waitAnyButton: bool = false
var ok: bool = false

var res := ResourceLoader
var progresses: Array = []
var packedScene: PackedScene = null

signal loadCompleted
signal anyButtonPressed

## Main

func _ready() -> void:
	pressAnyButton.modulate.a = 0
	loadBar.scale.x = 0
	progress.text = "0%"
	
	Logger.info("Loading '%s' scene..." % LSM.nextScene)
	res.load_threaded_request(LSM.nextScene)
	await loadCompleted
	
	packedScene = res.load_threaded_get(LSM.nextScene)
	if packedScene:
		if LSM.waitAnyButton:
			await anyButtonPressed

		get_tree().change_scene_to_packed(packedScene)
	else:
		Logger.err("Unable load '%s' scene!" % LSM.nextScene)

func _process(delta: float) -> void:
	nTime += delta
	
	if !loadComplete:
		# Loading next scene logic
		loadNextSceneLogic()
		
		# Animations
		animLoading(delta)
	
	animPressAnyButton()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		anyButtonPressed.emit()

## Util's

func loadNextSceneLogic() -> void:
	var status = res.load_threaded_get_status(LSM.nextScene, progresses)
	
	match status:
		res.THREAD_LOAD_LOADED:
			var isLoaded = loadBar.scale.x >= 0.99
			loadComplete = isLoaded
			waitAnyButton = isLoaded
			
			if waitAnyButton && !ok:
				ok = true
				loadCompleted.emit()
			
			loadBar.scale.x = 1
			loadIcon.visible = loadComplete
		res.THREAD_LOAD_IN_PROGRESS:
			var cProgress = progresses[0]
			loadBar.scale.x = cProgress
			progress.text = str(cProgress * 100) + "%"
		res.THREAD_LOAD_INVALID_RESOURCE:
			Logger.err("Unable load resourses for '%s' scene. Invalid resources!" % LSM.nextScene)
		res.THREAD_LOAD_FAILED:
			Logger.err("Failed load resourses for '%s' scene!" % LSM.nextScene)

func animPressAnyButton() -> void:
	if !loadComplete: return
	
	pressAnyButton.modulate.a = sin(PI * nTime) + 1
	pressAnyButton.scale = Vector2(
		cos(PI * nTime * 2) / 8 + 1,
		cos(PI * nTime * 2) / 8 + 1
	)

func animLoading(delta: float) -> void:
	loadIcon.rotation = nTime * 8
	
	loadBar.scale.x = lerp(loadBar.scale.x, progresses[0], delta * 2)
