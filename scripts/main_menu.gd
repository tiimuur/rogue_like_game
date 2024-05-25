extends VBoxContainer


func _on_play_button_pressed():
	Global.current_level -= 1
	get_tree().change_scene_to_file("res://scenes/map.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
	get_tree().set_pause(false)


func _ready():
	size = Vector2(
		get_viewport().get_size().x / 2,
		get_viewport().get_size().y / 2
	)
	position = Vector2(
		get_viewport().get_size().x * 0.25,
		get_viewport().get_size().y * 0.25
	)
