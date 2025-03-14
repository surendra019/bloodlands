extends Control


class_name SoundButton

# play sound when the button is pressed.
func _ready():
	gui_input.connect(func(event):
		if event is InputEventScreenTouch:
			if event.pressed:
				SoundManager.play_btn_sound()
		)
