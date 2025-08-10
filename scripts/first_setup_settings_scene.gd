extends Control

@onready var background = $Background
@onready var glowBottom = $GlowBottom
@onready var confirmButton = $Confirm

var aTime: float = 0.0
var confirmVisible: bool = false
var menus: Array[Control] = []
var currentMenu: Control
var lastMenu: Control
var confirmButtonVisible: bool = false

var glowBottomAnim = AnimationHelper.Animator.new()
var menusAnimIn = AnimationHelper.Animator.new()
var menusAnimOut = AnimationHelper.Animator.new()

signal confirmed(data: Dictionary)
signal confirm_show
signal confirm_hide
signal next_menu

## Main

func _ready() -> void:
	for node in get_children():
		if node.get_class() == "Control":
			menus.append(node)
			remove_child(node)
	
	confirmButton.position.y += 164
	
	connect("confirmed", onConfirmed)
	connect("confirm_show", onConfirmButtonShow)
	connect("confirm_hide", onConfirmButtonHide)
	
	AnimationHelper.eventHandler.connect(onAnimHandler)
	
	glowBottomAnim.timeline([
		[
			AnimationHelper.Keyframe.new(0, 1, 5),
			AnimationHelper.Keyframe.new(1, 0)
		]
	])
	menusAnimIn.timeline([
		[
			AnimationHelper.Keyframe.new(0, 128, 0.25, &"MENU_ENTER"),
			AnimationHelper.Keyframe.new(1, 0, 1)
		],
		[
			AnimationHelper.Keyframe.new(0, 0, 0.25),
			AnimationHelper.Keyframe.new(1, 1)
		]
	])
	menusAnimOut.timeline([
		[
			AnimationHelper.Keyframe.new(0, 0, 2),
			AnimationHelper.Keyframe.new(1, 128, 1, &"MENU_EXIT")
		],
		[
			AnimationHelper.Keyframe.new(0, 1, 2),
			AnimationHelper.Keyframe.new(1, 0)
		]
	])
	await Game.wait(1)
	await get_tree().process_frame

	for menu in menus:
		currentMenu = menu
		menusAnimIn.play(true)
		await next_menu
		
		lastMenu = menu
		menusAnimOut.play(true)

func _process(delta: float) -> void:
	aTime += delta
	
	background.texture.region.position.x = aTime * 16
	
	var glowBottomKey = glowBottomAnim.update(delta)
	if glowBottomKey:
		glowBottom.scale.y = glowBottomKey[0]
	
	var menuIn = menusAnimIn.update(delta)
	var menuOut = menusAnimOut.update(delta)
	
	if currentMenu:
		currentMenu.global_position.y = menuIn[0]
		currentMenu.modulate.a = menuIn[1]
	
	if lastMenu:
		lastMenu.global_position.y = menuOut[0]
		lastMenu.modulate.a = menuOut[1]
	
	confirmButton.position.y = lerp(
		confirmButton.position.y,
		float(618 if confirmButtonVisible else 618 + 128),
		delta * 16
	)
	confirmButton.disabled = !confirmButtonVisible

func onConfirmed(data: Dictionary) -> void:
	glowBottomAnim.play(true)
	
	match data.keys()[0]:
		"lang":
			GameSettings.language.value = data["lang"]
	
	confirmButtonVisible = false

func onConfirmButtonShow() -> void:
	if !confirmButtonVisible:
		confirmButtonVisible = true

func onConfirmButtonHide() -> void:
	if confirmButtonVisible:
		confirmButtonVisible = false

func onAnimHandler(callEvent: StringName) -> void:
	match callEvent:
		&"MENU_ENTER":
			add_child(currentMenu)
		&"MENU_EXIT":
			confirmButtonVisible = false
			remove_child(lastMenu)
