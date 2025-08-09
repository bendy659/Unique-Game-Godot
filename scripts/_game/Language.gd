extends Node

enum DataType { STRING, ARRAY }

const translation: Dictionary = {
	"startup": {
		"xdl": [
			"Создано на",
			"Created on"
		]
	},
	"loading": {
		"funFacts": [
			[ "Нет", "Да" ],
			[ "No", "Yes" ]
		]
	},
	"firstSetupSettings": {
		"good": [
			"Хорошо",
			"Good"
		]
	}
}

## Util's

func translate(key: String) -> Variant:
	var parts = key.split(".")
	var result = translation
	
	for part in parts:
		if result.has(part):
			result = result[part]
			continue
		else:
			Logger.warn("Unable find translation for key '%s'" % key)
			break
	
	var id = GameSettings.language.value
	return result[id]
