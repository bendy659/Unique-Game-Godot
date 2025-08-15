extends Node

var scene: PackedScene = load("res://scenes/AchievementManager-Scene.tscn")
var instance: Node

var achievments: Array[Achi] = [
	Achi.new("AchiNotFound", Vector2(0, 0)),
	Achi.new("example", Vector2(1, 0)),
	
	Achi.new("selectLanguage", Vector2(2, 0)),
	Achi.new("setupVolumes", Vector2(3, 0)),
]

signal show_achievement
signal hide_achievement

## Main

func _ready() -> void:
	show_achievement.connect(onShowAchievement)
	hide_achievement.connect(onHideAchievement)

func onShowAchievement(achiId: String, unlocked: bool) -> void:
	if !Game.canvas:
		await Game.canvas_found
	
	if instance:
		instance.queue_free()
	
	instance = scene.instantiate()
	instance["achiId"] = achiId
	instance["unlocked"] = unlocked
	Game.canvas.add_child(instance)

func onHideAchievement() -> void:
	Game.canvas.remove_child(instance)

## Util's

class Achi:
	var id: String
	var getup: bool
	var iconData: Vector2
	
	func _init(
		iid: String,
		iiconData: Vector2
	) -> void:
		id = iid
		iconData = iiconData
	
	func unlock() -> void:
		getup = true
		AchivementManager.show_achievement.emit(id, true)
	
	func lock() -> void:
		getup = false
		AchivementManager.show_achievement.emit(id, false)
	
	func getIconRect() -> Rect2:
		return Rect2(iconData.x * 32, iconData.y * 32, 32, 32)

func getAchi(achiId: String) -> Achi:
	for achi in achievments:
		if achi.id == achiId:
			return achi
	Logger.warn("Ачивка с id, содержащим " + achiId + ", не найдена!")
	return achievments[0]
