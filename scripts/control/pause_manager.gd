extends Node


@onready var pause_menu =  $"../CanvasLayer/Pause"

var game_paused = false


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		game_paused = !game_paused
		
	if game_paused:
		get_tree().set_pause(true)
		pause_menu.show()
	else:
		get_tree().set_pause(false)
		pause_menu.hide()



func _on_resume_button_pressed():
	game_paused = !game_paused


func _on_main_menu_button_pressed():
	get_tree().set_pause(false)
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
