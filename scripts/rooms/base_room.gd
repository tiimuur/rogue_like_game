extends Node2D
class_name BaseRoom


var id
var walls = [null, null]
var player_here = false

const vertical_wall_preload = preload("res://scenes/rooms/vertical_wall.tscn")
const horizontal_wall_preload = preload("res://scenes/rooms/horizontal_wall.tscn")
const down_fix_preload = preload("res://scenes/rooms/down_fix.tscn")


func get_player():
	return get_parent().get_player()


func set_id(value):
	id = value


func prepare_walls():
	walls[1] = Node2D.new()
	walls[1].set_name("StaticWalls")
	get_parent().add_child(walls[1])
	fill_holes(true)


func fill_holes(stat):
	if not stat:
		walls[0] = Node2D.new()
		walls[0].set_name("DynamicWalls")
		get_parent().add_child(walls[0])
	
	var ind = 1 if stat else 0
	
	if get_parent().has_edge(id, id - 1) != stat:
		var vert_wall = vertical_wall_preload.instantiate()
		vert_wall.set_position(Vector2(
			position.x, 
			position.y + (Global.room_size - Global.hole_size - 4 * Global.tile_size) / 2 - Global.tile_size
		))
		walls[ind].add_child(vert_wall)
	
	if get_parent().has_edge(id, id + 1) != stat:
		var vert_wall = vertical_wall_preload.instantiate()
		vert_wall.set_position(Vector2(
			position.x + Global.room_size - Global.tile_size, 
			position.y + (Global.room_size - Global.hole_size - 4 * Global.tile_size) / 2 - Global.tile_size
		))
		walls[ind].add_child(vert_wall)
	
	if get_parent().has_edge(id, id - 3) != stat:
		var hor_wall = horizontal_wall_preload.instantiate()
		hor_wall.set_position(Vector2(
			position.x + (Global.room_size - Global.hole_size) / 2 - Global.tile_size, 
			position.y
		))
		walls[ind].add_child(hor_wall)
	
	if get_parent().has_edge(id, id + 3) != stat:
		var hor_wall = horizontal_wall_preload.instantiate()
		hor_wall.set_position(Vector2(
			position.x + (Global.room_size - Global.hole_size) / 2 - Global.tile_size, 
			position.y + Global.room_size - 3 * Global.tile_size
		))
		walls[ind].add_child(hor_wall)
		
		if not stat:
			var down_fix = down_fix_preload.instantiate()
			down_fix.set_position(Vector2(
				position.x + (Global.room_size - Global.hole_size) / 2 - Global.tile_size, 
				position.y + Global.room_size - 2 * Global.tile_size
			))
			walls[0].add_child(down_fix)


func delete_dynamic_walls():
	get_parent().remove_child(walls[0])
	walls[0] = null


func _on_area_2d_body_entered(body):
	if body.get_name() == "Player":
		player_here = true


func _on_area_2d_body_exited(body):
	if body.get_name() == "Player":
		player_here = false


func _ready():
	prepare_walls()
