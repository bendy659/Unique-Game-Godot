extends Node

## === Load Scene Manager === ##

var nextScene: String
var waitAnyButton: bool

## Util's

func loadScene(scenePath: String, waitAnyButton: bool = true) -> void:
	nextScene = "res://scenes/" + scenePath + ".tscn"
	await AchivementManager.hide_achievement
	await Game.wait(1)
	
	get_tree().change_scene_to_file("res://scenes/LSM-Scene.tscn")
