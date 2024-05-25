extends VBoxContainer


func _ready():
	size = Vector2(
			get_viewport().get_size().x / 2,
			get_viewport().get_size().y / 2
		)
	position = Vector2(
		get_viewport().get_size().x * 0.25,
		get_viewport().get_size().y * 0.25
	)
	set_process_mode(PROCESS_MODE_ALWAYS)
	hide()


func _on_resume_button_pressed():
	get_parent().get_parent().resume_game()


func _on_quit_button_pressed():
	get_parent().get_parent().quit_game()
