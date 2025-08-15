extends Control

@onready var plate = $Plate
@onready var outline = $Plate/Outline
@onready var icon = $Plate/Icon
@onready var title = $Plate/Title
@onready var achiName = $Plate/Name
@onready var achiDesc = $Plate/Desc
@onready var glow = $Glow
@onready var punyk = $Punyk
@onready var sfx = $SFX

@export var achiId: String
@export var unlocked: bool

var animator = AnimationHelper.Animator.new()
var achiData: AchivementManager.Achi
var achiIcons = load("res://textures/achievements_atlas.png")
var colors: Dictionary = {
	"UNLOCK": Color(1, 1, 0),
	"LOCK": Color(1, 0, 0)
}

## Main

func _ready() -> void:
	punyk.emitting = false
	
	set_process(false)
	
	achiData = AchivementManager.getAchi(achiId)
	
	var atlas = AtlasTexture.new()
	atlas.atlas = achiIcons
	atlas.region = AchivementManager.getAchi(achiId).getIconRect()
	icon.texture = atlas
	plate.position.y = 720 + plate.size.y
	glow.scale.y = 0
	
	title.text = Language.translate("achievements.title.unlock") if unlocked else Language.translate("achievements.title.lock")
	achiName.text = Language.translate("achievements." + achiData.id + ".name")
	achiDesc.text = Language.translate("achievements." + achiData.id + ".desc")
	
	var aColor = colors["UNLOCK"] if unlocked else colors["LOCK"]
	outline.texture.color_ramp.colors[0] = aColor
	title.modulate = aColor
	glow.texture.gradient.colors[0] = aColor
	punyk.color = aColor
	
	sfx.pitch_scale = 1.1 if unlocked else 0.85
		
	AnimationHelper.eventHandler.connect(onAnimatorEvent)
	
	animator.timelines({
		&"SHOW": [
			[   # For plate
				AnimationHelper.Keyframe.new(0, 720 + plate.size.y, 0.25, &"NEW_ACHIEVEMENT_EVENT"),
				AnimationHelper.Keyframe.new(1, 720 - plate.size.y)
			],
			[   # For glow
				AnimationHelper.Keyframe.new(0, 1, 5),
				AnimationHelper.Keyframe.new(1, 0)
			]
		],
		&"HIDE": [
			[   # For plate
				AnimationHelper.Keyframe.new(0, 720 - plate.size.y, 5),
				AnimationHelper.Keyframe.new(1, 720 + plate.size.y)
			],
			[   # For glow
				AnimationHelper.Keyframe.new(0, 0),
				AnimationHelper.Keyframe.new(1, 0)
			]
		]
	})
	set_process(true)
	await get_tree().process_frame

	animator.play(true, &"SHOW")
	await Game.wait(5)
	
	animator.play(true, &"HIDE")
	await Game.wait(1)
	
	set_process(false)
	AchivementManager.hide_achievement.emit()

func _process(delta: float) -> void:
	var keys = animator.update(delta)
	
	if animator.isPlaying:
		plate.position.y = keys[0]
		glow.scale.y = keys[1]
	
	outline.texture.noise.offset += Vector3(delta * 16, delta * 16, 0)

func onAnimatorEvent(callEvent: StringName) -> void:
	if callEvent == &"NEW_ACHIEVEMENT_EVENT":
		punyk.emitting = true
		sfx.volume_linear = 0.5
		sfx.play()
