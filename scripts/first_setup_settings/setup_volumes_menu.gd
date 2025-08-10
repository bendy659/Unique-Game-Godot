extends Control

@onready var title = $Title
@onready var audioStream = $AudioStream

func _ready() -> void:
	title.text = Language.translate("firstSetupSettings.setupVolumes.title")
	GameSettings.soundMaster.setStream(audioStream)
	await get_parent().confirmed

func _process(delta: float) -> void:
	pass
