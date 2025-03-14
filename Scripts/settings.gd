extends Control

@onready var option_category_container = $Body/Panel/OptionCategoryContainer
@onready var scroll_container = $Body/ScrollContainer

const OPTION_CATEGORY_PREFAB = preload("res://Scenes/Prefabs/option_category_prefab.tscn")

var last_setting: String

func _ready():
	load_settings()
	
# adds option to the option category container.
func add_option_category(category_id: String):
	var option = OPTION_CATEGORY_PREFAB.instantiate()
	option_category_container.add_child(option)
	option.initialize(category_id)
	option.selected.connect(func(opt):
		if option_category_container:
			for i in option_category_container.get_children():
				if i.current_state == i.STATE.SELECTED && i != opt:
					i.set_state(i.STATE.UNSELECTED)
		)

# loads all the settings.
func load_settings():
	for i in Manager.settings:
		add_option_category(i)
	
	var id = option_category_container.get_children()[0].set_state(option_category_container.get_children()[0].STATE.SELECTED)
	load_settings_with_respect_to_category(id)
	for j in option_category_container.get_children():
			j.selected.connect(func(option):
				if last_setting and last_setting != option.id:
					load_settings_with_respect_to_category(option.id)
					last_setting = option.id
				)
	
func load_settings_with_respect_to_category(id: String):
	var setting_scene = load(Manager.setting_to_scene[id]).instantiate()
	scroll_container.add_child(setting_scene)
	
	for i in Manager.settings[id]:
		var head = i["head"]
		var settings = i["settings"]
		setting_scene.add_section(head, settings)
		
		



func _on_closet_btn_pressed():
	queue_free()
