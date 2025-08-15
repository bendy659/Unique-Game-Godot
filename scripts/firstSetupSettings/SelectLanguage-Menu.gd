extends Control

@onready var title = $Title
@onready var selectBoxControl = $SelectBoxControl
@onready var selectBox = $SelectBoxControl/SelectBox
@onready var subtitle = $SelectBoxControl/Subtitle
@onready var ruLang = $Container/RuLang
@onready var ruIcon = $Container/RuLang/Icon
@onready var enLang = $Container/EnLang
@onready var enIcon = $Container/EnLang/Icon
@onready var selectSFX = $SelectSFX
var confirm: Button

var aTime: float = 0.0
var langSelected: TextureButton
var langSelectedID: int
var selected: bool = false

var iconsPos: Array = []

var parent: Control
var tree: SceneTree

## Main

func _ready() -> void:
	parent = get_parent()
	tree = get_tree()

func start() -> void:
	set_process(false)
	
	confirm = parent.get_node("Confirm")
	
	ruIcon.pressed.connect(onRuSelected)
	enIcon.pressed.connect(onEnSelected)
	confirm.pressed.connect(onConfirmed)
	readyProccess()
	set_process(true)
	readyEnd()

func _process(delta: float) -> void:
	aTime += delta

	selectBox.scale = Vector2(
		sin(aTime * PI * 4) / 64 + 1,
		sin(aTime * PI * 4) / 64 + 1
	)
	
	if !selected:
		ruIcon.scale = ruIcon.scale.lerp(
			Vector2(1, 1) if ruIcon.is_hovered() else Vector2(0.9, 0.9),
			delta * 16
		)
		enIcon.scale = enIcon.scale.lerp(
			Vector2(1, 1) if enIcon.is_hovered() else Vector2(0.9, 0.9),
			delta * 16
		)
	
	selectBoxControl.global_position = selectBoxControl.global_position.lerp(
		iconsPos[0 if langSelected == ruIcon else 1],
		delta * 16
	)
	
	selectBoxControl.visible = langSelected != null
	
	if selected:
		var currentLangIcon = {
			"selected": ruLang if langSelected == ruIcon else enLang,
			"unselected": ruLang if langSelected == enIcon else enIcon
		}
		
		# X-pos
		currentLangIcon["selected"].global_position.x = lerp(
			currentLangIcon["selected"].global_position.x,
			float(1280 / 2 - currentLangIcon["selected"].size.x / 2),
			delta * 16
		)
		
		# Y-pos
		currentLangIcon["unselected"].global_position.y = lerp(
			currentLangIcon["unselected"].global_position.y,
			float(720 + 64),
			delta * 4
		)
		
		# Hide select box
		selectBoxControl.modulate.a = lerp(
			selectBoxControl.modulate.a,
			0.0,
			delta * 16
		)

func onRuSelected() -> void:
	langSelectedID = 0
	iconsPos[0] = ruIcon.global_position
	langSelected = ruIcon
	title.text = Language.translate("firstSetupSettings.selectLanguage.title", 0)
	subtitle.text = "Русский"
	confirm.text = Language.translate("firstSetupSettings.confirm", 0)
	selectSFX.play()
	
	parent.emit_signal("confirm_show")

func onEnSelected() -> void:
	langSelectedID = 1
	iconsPos[1] = enIcon.global_position
	langSelected = enIcon
	title.text = Language.translate("firstSetupSettings.selectLanguage.title", 1)
	subtitle.text = "English"
	confirm.text = Language.translate("firstSetupSettings.confirm", 1)
	selectSFX.play()
	
	parent.emit_signal("confirm_show")

func onConfirmed() -> void:
	ruIcon.disabled = langSelected == enIcon
	enIcon.disabled = langSelected == ruIcon
	
	parent.emit_signal("confirmed", { "lang": langSelectedID })
	parent.get_node("Tip").text = Language.translate("firstSetupSettings.tip")
	AchivementManager.getAchi("selectLanguage").unlock()
	title.text = "Отлично" if langSelected == ruIcon else "Good"
	title.modulate = Color(0, 1, 0)
	await Game.wait(2)
	
	parent.emit_signal("next_menu")

## Util's

func readyProccess() -> void:
	await tree.process_frame

	ruIcon.pivot_offset = Vector2(128, 128)
	enIcon.pivot_offset = Vector2(128, 128)
	iconsPos = [Vector2.ZERO, Vector2.ZERO]

func readyEnd() -> void:
	await parent.confirmed
	
	selected = true
	parent.emit_signal("confirm_hide")
