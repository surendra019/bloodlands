extends VBoxContainer

const SETTING_SECTION_HEAD = preload("res://Scenes/Prefabs/setting_section_head.tscn")
const CHECK_BOX = preload("res://Scenes/Prefabs/check_box.tscn")
const SETTING_PROGRESS_OPTION = preload("res://Scenes/Prefabs/setting_progress_option.tscn")

#adds a setting section to the container.
func add_section(head_name: String, setting_array):
	var v_box = VBoxContainer.new()
	self.add_child(v_box)
	v_box.set("theme_override_constants/separation", 20)
	var head = SETTING_SECTION_HEAD.instantiate()
	v_box.add_child(head)
	head.set_label(head_name)
	var h_box = HBoxContainer.new()
	v_box.add_child(h_box)
	
	
	
	for i in setting_array:
		
		if h_box.get_child_count() == 2:
			var new = HBoxContainer.new()
			v_box.add_child(new)
			h_box = new
			
		var type = i["type"]
		var value = i["value"]
		var n = i["name"]
		if type == Manager.SETTING_TYPE.CHECK_BOX:
			var check_box = CHECK_BOX.instantiate()
			h_box.add_child(check_box)
			check_box.set_setting_label(n)
			check_box.set_value(value)
			check_box.size_flags_horizontal = Control.SIZE_EXPAND
		else:
			var progress_bar = SETTING_PROGRESS_OPTION.instantiate()
			h_box.add_child(progress_bar)
			progress_bar.set_setting_label(n)
			progress_bar.set_progress_bar_value(value)
			progress_bar.size_flags_horizontal = Control.SIZE_EXPAND
		
	
	
	
