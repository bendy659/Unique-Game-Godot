extends Control

@onready var box = $Box
@onready var button = $Button

var animator = AnimationHelper.Animator.new()

var words = [
	"Лох", "Идиот", "Гений", "Тупой", "XD", "XDDDS", "Лол"
]

## Main

func _ready() -> void:
	# Setup animation
	animator.timeline([
		[
			AnimationHelper.Keyframe.new(2, box.position.x - 256),
			AnimationHelper.Keyframe.new(6, box.position.x + 256)
		],
		[
			AnimationHelper.Keyframe.new(2, box.position.y + 256, 0.35),
			AnimationHelper.Keyframe.new(4, box.position.y - 256, 5),
			AnimationHelper.Keyframe.new(6, box.position.y + 256)
		],
		[
			AnimationHelper.Keyframe.new(2, box.rotation_degrees),
			AnimationHelper.Keyframe.new(6, box.rotation_degrees + 360 * 4)
		],
		[
			AnimationHelper.Keyframe.new(1, words[randi_range(0, words.size() - 1)]),
			AnimationHelper.Keyframe.new(2, words[randi_range(0, words.size() - 1)]),
			AnimationHelper.Keyframe.new(3, words[randi_range(0, words.size() - 1)]),
			AnimationHelper.Keyframe.new(4, words[randi_range(0, words.size() - 1)]),
			AnimationHelper.Keyframe.new(5, words[randi_range(0, words.size() - 1)]),
			AnimationHelper.Keyframe.new(6, words[randi_range(0, words.size() - 1)])
		],
		[
			AnimationHelper.Keyframe.new(0, Color(1, 0, 0)),
			AnimationHelper.Keyframe.new(1, Color(1, 1, 0)),
			AnimationHelper.Keyframe.new(2, Color(0, 1, 0)),
			AnimationHelper.Keyframe.new(3, Color(0, 1, 1)),
			AnimationHelper.Keyframe.new(4, Color(0, 0, 1)),
			AnimationHelper.Keyframe.new(5, Color(1, 0, 1)),
			AnimationHelper.Keyframe.new(6, Color(1, 0, 0))
		]
	])
	
	# Starting
	animator.play()

func _process(delta: float) -> void:
	var keys = animator.update(delta)
	
	box.position.x = keys[0]
	box.position.y = keys[1]
	box.rotation_degrees = keys[2]
	$Label.text = keys[3]
	box.modulate = keys[4]

func _on_button_pressed() -> void:
	animator.play(true)
