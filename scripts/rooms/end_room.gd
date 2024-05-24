extends BaseRoom
class_name EndRoom


const critical_position_x = 3 * Global.room_size + 2 * Global.coridor_size - Global.tile_size
const critical_position_y = critical_position_x - Global.tile_size


func _on_area_2d_body_exited(body):
	if body.get_name() == "Player":
		player_here = false
		if (body.get_position().x >= critical_position_x or 
			body.get_position().y >= critical_position_y):
			get_tree().change_scene_to_file("res://scenes/hub.tscn")
