extends Control

@onready var title = $Title
@onready var masterVolumeSlider = $MasterVolumeSlider
@onready var masterVolumeLabel = $MasterVolumeLabel
@onready var masterVolumeSFX = $MasterVolumeSFX
var confirm: Button

var aTime: float = 0.0

var parent: Control
var tree: SceneTree

func _ready() -> void:
	parent = get_parent()
	tree = get_tree()

func start() -> void:
	title.text = Language.translate("firstSetupSettings.setupVolumes.title")
	confirm = parent.get_node("Confirm")
	
	masterVolumeSlider.value_changed.connect(onMasterVolumeChange)
	confirm.pressed.connect(onConfirmed)
	await Game.wait(1)
	
	parent.emit_signal("confirm_show")
	await parent.confirmed

func _process(delta: float) -> void:
	aTime += delta

func onMasterVolumeChange(value: float) -> void:
	masterVolumeLabel.text = ("%d" % (value * 100)) + "%"
	masterVolumeSFX.play()

func onConfirmed() -> void:
	AchivementManager.getAchi("setupVolumes").unlock()
	parent.emit_signal("confirmed", { "soundMasterVolume": masterVolumeSlider.value })
	
	title.text = Language.translate("firstSetupSettings.good")
	title.modulate = Color(0, 1, 0)
