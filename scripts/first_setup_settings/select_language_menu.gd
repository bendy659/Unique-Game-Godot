extends Control

@onready var title = $Title
@onready var selectBoxControl = $SelectBoxControl
@onready var selectBox = $SelectBoxControl/SelectBox
@onready var subtitle = $SelectBoxControl/Subtitle
@onready var ruLang = $Container/RuLang
@onready var ruIcon = $Container/RuLang/Icon
@onready var enLang = $Container/EnLang
@onready var enIcon = $Container/EnLang/Icon
var confirm: Button

var aTime: float = 0.0
var langSelected: TextureButton

## Main

func _ready() -> void:
	confirm = get_parent().get_node("Confirm")
	
	var langsButton = [
		ruLang,
		enLang
	]
	for i in langsButton:
		i.pivot_offset = Vector2(
			i.size.x / 2,
			i.size.y / 2
		)
	
	ruIcon.pressed.connect(onRuSelected)
	enIcon.pressed.connect(onEnSelected)
	confirm.pressed.connect(onConfirmed)

func _process(delta: float) -> void:
	aTime += delta
	
	animations(delta)

## Util's

func animations(delta: float) -> void:
	selectBox.scale = Vector2(
		sin(aTime * PI * 4) / 64 + 1,
		sin(aTime * PI * 4) / 64 + 1
	)
	
	var ruLangButtonScale = Vector2(1, 1) if ruIcon.is_hovered() else Vector2(0.9, 0.9)
	ruIcon.scale = lerp(
		ruLang.scale,
		ruLangButtonScale,
		delta * 16
	)
	var enLangButtonScale = Vector2(1, 1) if enIcon.is_hovered() else Vector2(0.9, 0.9)
	enIcon.scale = lerp(
		enLang.scale,
		enLangButtonScale,
		delta * 16
	)
	
	selectBoxControl.global_position.x = lerp(
		selectBoxControl.global_position.x,
		langSelected.global_position.x if langSelected else 1280 / 2 - selectBoxControl.size.x / 2,
		delta * 16
	)
	
	selectBoxControl.visible = langSelected != null
	

func onRuSelected() -> void:
	langSelected = ruIcon
	title.text = "Выбери язык"
	subtitle.text = "Русский"

func onEnSelected() -> void:
	langSelected = enIcon
	title.text = "Select language"
	subtitle.text = "English"

func onConfirmed() -> void:
	get_parent().emit_signal("confirmed", { "lang": 0 if langSelected == ruIcon else 1 })
	await Game.wait(2)
	
	get_parent().emit_signal("next_menu")
