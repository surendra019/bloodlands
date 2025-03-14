extends Node

enum SETTING_TYPE {CHECK_BOX, PROGRESS_BAR}

var settings = {
	"Graphics": [
		{
			"head": "Shadow",
			"settings": [
				{
					"type": SETTING_TYPE.CHECK_BOX,
					"name": "Enabled",
					"value": false
				},
				{
					"type": SETTING_TYPE.PROGRESS_BAR,
					"name": "Intensity",
					"value": 50
				}
			]
		}
	]
}

var setting_to_scene = {
	"Graphics": "res://Scenes/Setting Comoponents/graphics.tscn"
}
