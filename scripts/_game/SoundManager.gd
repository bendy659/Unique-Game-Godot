extends Node

var chanels: Dictionary = {
	"general": {
		"volume": 1,
		"streams": null
	},
	"music": {
		"volume": 1,
		"streams": {}
	},
}

func get_volume(chanel: String, original: bool = false) -> float:
	if original:
		return chanels[chanel]["volume"]
	else:
		return chanels[chanel]["volume"] * chanels["general"]["volume"]

func set_volume(chanel: String, volume: float = 1) -> void:
	chanels[chanel]["volume"] = volume
