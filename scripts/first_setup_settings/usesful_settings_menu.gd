extends Control

@onready var title = $Title
var confirm: Button

var aTime: float = 0.0

var parent: Control
var tree: SceneTree

func _ready() -> void:
	parent = get_parent()
	tree = get_tree()

func start() -> void:
	title.text = Language.translate("firstSetupSettings.usesfulSettings.title")
	confirm = parent.get_node("Confirm")
	
	confirm.pressed.connect(onConfirmed)
	await Game.wait(1)
	
	parent.emit_signal("confirm_show")
	await parent.confirmed

func _process(delta: float) -> void:
	aTime += delta

func onConfirmed() -> void:
	pass
