extends Node

## === Load Scene Manager === ##

var nextScene: String
var waitAnyButton: bool

## Util's

func loadScene(scenePath: String, waitAnyButton: bool = true) -> void:
	nextScene = "res://scenes/" + scenePath + ".tscn"
	get_tree().change_scene_to_file("res://scenes/load_scene_manager.tscn")
