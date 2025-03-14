extends Node3D

@onready var player = $PlayerContainer/Player
@onready var camera = $Camera3D
@onready var gui = $GUI

var current_selected_character # reference of current selected character for rotation along its axis.
const SETTINGS = preload("res://Scenes/settings.tscn")

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			set_current_selected_character(event.position)
		else:
			current_selected_character = null
	if event is InputEventScreenDrag and current_selected_character:
		current_selected_character.rotation.y += event.relative.x / 100
		

# sets the selected character as a reference for rotation on its axis.
func set_current_selected_character(input_position):
	var state = get_world_3d().direct_space_state
	var start = camera.project_ray_origin(input_position)
	var end = camera.project_position(input_position, 100)
	var params = PhysicsRayQueryParameters3D.new()
	params.from = start
	params.to = end
	
	var result = state.intersect_ray(params)
	if result:
		current_selected_character = result["collider"]
	


func _on_emote_btn_pressed():
	player.animation_player.play("dancing")


func _on_settings_btn_pressed():
	var s = SETTINGS.instantiate()
	gui.add_child(s)
