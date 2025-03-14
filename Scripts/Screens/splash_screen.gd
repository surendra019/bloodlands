extends Control

@onready var label_container = $LabelContainer

func _ready():
	await animate_label_container()
	print("animation finished")

# to animate the label container.
func animate_label_container():
	var t = get_tree().create_tween()
	t.tween_property(label_container, "modulate:a", 1, 4)
	await t.finished
