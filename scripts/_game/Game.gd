extends Node

## Main

func _input(event: InputEvent) -> void:
	var crashGame = Input.is_action_just_pressed("CrashGame")
	
	if crashGame:
		Logger.err("==== Game intentional crashed! ====")

## Util's

func wait(ms: float) -> void:
	await get_tree().create_timer(ms).timeout
