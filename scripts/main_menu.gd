extends Node2D


func _on_play_button_pressed():
	Global.current_level -= 1
	get_tree().change_scene_to_file("res://scenes/map.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
	get_tree().set_pause(false)
