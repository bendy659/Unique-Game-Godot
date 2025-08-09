extends Node

var logList: Array[Dictionary] = [
	{
		"label": "==== XD_LOGGER_ACTIVED ====",
		"level": levels["warn"]
	}
]

const levels: Dictionary = {
	"info": { "level": "[INFO]", "color": Color(0.25, 0.25, 0.25) },
	"warn": { "level": "[WARNING]", "color": Color(0.75, 0.75, 0) },
	"err": { "level": "[ERROR]", "color": Color(0.75, 0, 0) },
	"succ": { "level": "[SUCCESSFUL]", "color": Color(0, 0.75, 0) }
}

## Util's

func addLog(label: String, logLevel: Dictionary, crash: bool = false) -> void:
	logList.append({ "label": label, "level": logLevel })
	print( "%s %s" % [logLevel["level"], label] )
	
	if crash:
		get_tree().change_scene_to_file("res://scenes/crash_scene.tscn")

func info(label: String) -> void:
	addLog(label, levels["info"])

func warn(label: String) -> void:
	addLog(label, levels["warn"])

func err(label: String) -> void:
	addLog(label, levels["err"], true)

func succ(label: String) -> void:
	addLog(label, levels["succ"])
