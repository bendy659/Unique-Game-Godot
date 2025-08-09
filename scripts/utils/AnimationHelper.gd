extends Node

signal animationStarted
signal animationStoped
signal eventHandler(eName: StringName)

class Keyframe:
	var time: float
	var value: Variant
	var easing: float
	var callEvent: StringName
	var callEventTriggered: bool
	
	func _init(
		itime: float,
		ivalue: Variant,
		ieasing: float = 1.0,
		icallEvent: StringName = &"_NONE_"
	) -> void:
		time = itime
		value = ivalue
		easing = ieasing
		callEvent = icallEvent
		callEventTriggered = false

class Animator:
	var animations: Dictionary = {}
	var currentAnimation: StringName = &"DEFAULT"
	var currentTime: float
	var isPlaying: bool = false
	var timeScale: float = 1.0
	
	func timeline(timeline: Array[Array]) -> void:
		animations = { &"DEFAULT": timeline }
	func timelines(timeline: Dictionary) -> void:
		animations = timeline
	
	func timeSpeed(multiply: float) -> void:
		timeScale = multiply
	
	func play(force: bool = false, animationName: StringName = &"DEFAULT") -> void:
		if force:
			currentTime = 0
			
			# Clear triggers
			for chn in animations[animationName]:
				for key in chn:
					key.callEventTriggered = false
		
		# Change next animation
		currentAnimation = animationName
		
		isPlaying = true
		AnimationHelper.animationStarted.emit()
	
	func pause(paused: bool) -> void:
		isPlaying = paused
	
	func stop() -> void:
		isPlaying = false
		AnimationHelper.animationStoped.emit()
	
	func update(delta: float) -> Array:
		var result: Array = []
		
		if !isPlaying:
			AnimationHelper.animationStoped.emit(currentAnimation)
			return result
		
		currentTime += delta * timeScale
		
		var chanels: Array = animations.get(currentAnimation, [])
		for chn in chanels:
			if chn.size() < 1:
				continue
			
			var currentKeyframe
			var nextKeyframe
			
			for key in chn:
				if key.callEvent != &"_NONE_" and !key.callEventTriggered and currentTime >= key.time:
					key.callEventTriggered = true
					AnimationHelper.eventHandler.emit(key.callEvent)
				
				if key.time <= currentTime:
					currentKeyframe = key
				elif key.time > currentTime and nextKeyframe == null:
					nextKeyframe = key
				
				if currentKeyframe and nextKeyframe:
					break
			
			if !currentKeyframe:
				currentKeyframe = chn[0]
				nextKeyframe = chn[0] if chn.size() == 1 else chn[1]
			
			if !nextKeyframe:
				nextKeyframe = currentKeyframe
			
			var totalTime = nextKeyframe.time - currentKeyframe.time
			var progress = (currentTime - currentKeyframe.time) / totalTime if totalTime > 0 else 1
			progress = clamp(progress, 0, 1)
			
			var eased = ease(progress, currentKeyframe.easing)
			var interpolated = interpolateValue(currentKeyframe.value, nextKeyframe.value, eased)
			result.append(interpolated)
		
		return result
	
	func interpolateValue(from: Variant, to: Variant, t: float) -> Variant:
		var a = typeof(from)
		var b = typeof(to)
		
		var blackList = [TYPE_STRING, TYPE_STRING_NAME, TYPE_BOOL, TYPE_OBJECT]
		for i in blackList:
			if typeof(from) == i: return from
		
		return lerp(float(from), float(to), t)
