extends Node

var scene: PackedScene = load("res://scenes/achievement_manager_scene.tscn")
var instance: Node

var achievments: Array[Achi] = [
	Achi.new("example", false)
]

signal show_achievement
signal hide_achievement

## Main

func _ready() -> void:
	show_achievement.connect(onShowAchievement)
	hide_achievement.connect(onHideAchievement)

func onShowAchievement(achiId: String) -> void:
	if !Game.canvas:
		Game.updateCanvas()
		await Game.canvas_found
	
	instance = scene.instantiate()
	scene["achiId"] = achiId
	Game.canvas.add_child(instance)
	await Game.wait(5)
	
	hide_achievement.emit(achiId)

func onHideAchievement() -> void:
	Game.canvas.remove_child(instance)


## Util's

class Achi:
	var id: String
	var getup: bool
	var iconData: Rect2
	
	func _init(
		iid: String,
		igetup: bool = false
	) -> void:
		id = iid
		getup = igetup
	
	func unlock() -> void:
		getup = true
		emit_signal("show_achievement")
	
	func lock() -> void:
		getup = false
		emit_signal("show_achievement")

func getAchi(achiId: String) -> Achi:
	for achi in achievments:
		if achi.id == achiId:
			return achi
	
	return Achi.new("AchiNotFound")
