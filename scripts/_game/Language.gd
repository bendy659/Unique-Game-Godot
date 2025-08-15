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
		},
		"usesfulSettings": {
			"title": ["Полезные настройки", "Usesful settings"],
			"setting0": ["Ничего", "Nothing"],
			"setting1": ["Заряд батареи", "Buttery energy"],
			"setting2": ["OIIA", "OIIA"]
		}
	},
	
	"achievements": {
		"title": {
			"unlock": ["Новое достижение", "New achievement"],
			"lock": ["Достижение отозванно", "Achievement revoked"]
		},
		
		"AchiNotFound": {
			"name": ["Не найдено!", "Not found!"],
			"desc": ["Это баг. И мне как-то пофиг", "This is bug. It's OK"]
		},
		
		"example": {
			"name": ["Вставте имя", "Insert name"],
			"desc": ["Вставте описание", "Insert description"]
		},
		"selectLanguage": {
			"name": ["Я люблю Русский)", "Im love English)"],
			"desc": ["Рашка!", "OK"]
		},
		"setupVolumes": {
			"name": ["И ушам не больно", "Approved by ears"],
			"desc": ["Обезопасьте свои уши от Bass-boos'а", "Protect your ears from Bass-boost crimes"]
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
			return key
	
	var id = overrideLangId if overrideLangId != -1 else GameSettings.language.value
	
	return result[id]
