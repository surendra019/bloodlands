extends Node

@onready var btn_sound = $BtnSound

func play_btn_sound():
	btn_sound.play(.1)
