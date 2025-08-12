extends Control

@onready var plate = $Plate
@onready var outline = $Plate/Outline
@onready var glow = $Glow

@export var achiId: String
@export var unlocked: bool

var animator = AnimationHelper.Animator.new()

## Main

func _ready() -> void:
	set_process(false)
	
	plate.position.y = 720 + plate.size.y
	glow.scale.y = 0
	
	AnimationHelper.eventHandler.connect(onAnimatorEvent)
	
	animator.timelines({
		&"SHOW": [
			[   # For plate
				AnimationHelper.Keyframe.new(0, 720 + plate.size.y, 0.25, &"NEW_ACHIEVEMENT_EVENT"),
				AnimationHelper.Keyframe.new(1, 720 - plate.size.y)
			],
			[   # For glow
				AnimationHelper.Keyframe.new(0, 2, 5),
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
	await Game.wait(1)
	
	animator.play(true, &"SHOW")
	await Game.wait(5)
	
	animator.play(true, &"HIDE")
	await Game.wait(1)
	
	set_process(false)
	#AchivementManager.hide_achievement.emit(achiId)

func _process(delta: float) -> void:
	var keys = animator.update(delta)
	
	if animator.isPlaying:
		plate.position.y = keys[0]
		glow.scale.y = keys[1]
	
	outline.texture.noise.offset += Vector3(delta * 16, delta * 16, 0)

func onAnimatorEvent(callEvent: StringName) -> void:
	if callEvent == &"NEW_ACHIEVEMENT_EVENT":
		pass
