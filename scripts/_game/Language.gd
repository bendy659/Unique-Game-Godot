extends Node

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
		"good": ["Хорошо", "Good"],
		"confirm": ["Подтвердить", "Confirm"],
		"tip": ["Позже вы сможете изменить всё в настройках", "Later you can change everything in the settings."],
		
		"selectLanguage": {
			"title": ["Выбери язык", "Select language"],
			"subtitle": ["Русский", "English"]
		},
		"setupVolumes": {
			"title": ["Настрой общую громкость", "Adjust the master volume"],
			"expand": ["Расширенно", "Expanded"]
		}
	}
}

## Util's

func translate(key: String, overrideLangId: int = -1) -> Variant:
	var parts = key.split(".")
	var result = translation
	
	for part in parts:
		if result.has(part):
			result = result[part]
			continue
		else:
			Logger.warn("Unable find translation for key '%s'" % key)
			break
	
	var id = overrideLangId if overrideLangId != -1 else GameSettings.language.value
	return result[id]
