extends Node2D


var id = 0
var type = "battle"
var edges_node = null
var vertical_wall_preload = preload("res://firstTryToGetRandom/vertical_wall.tscn")
var horizontal_wall_preload = preload("res://firstTryToGetRandom/horizontal_wall.tscn")
var down_fix_preload = preload("res://firstTryToGetRandom/down_fix.tscn")


func _ready():
	if not get_parent().has_edge(id, id - 1):
		var vert_wall = vertical_wall_preload.instantiate()
		vert_wall.name = "vw" + name + "0"
		vert_wall.position.x = position.x
		vert_wall.position.y = position.y + 5 * Global.tile_size
		get_parent().add_child(vert_wall)
	if not get_parent().has_edge(id, id + 1):
		var vert_wall = vertical_wall_preload.instantiate()
		vert_wall.name = "vw" + name + "1"
		vert_wall.position.x = position.x + 19 * Global.tile_size
		vert_wall.position.y = position.y + 5 * Global.tile_size
		get_parent().add_child(vert_wall)
	if not get_parent().has_edge(id, id - 3):
		var hor_wall = horizontal_wall_preload.instantiate()
		hor_wall.name = "hw" + name + "0"
		hor_wall.position.x = position.x + 7 * Global.tile_size
		hor_wall.position.y = position.y
		get_parent().add_child(hor_wall)
	if not get_parent().has_edge(id, id + 3):
		var hor_wall = horizontal_wall_preload.instantiate()
		hor_wall.name = "hw" + name + "1"
		hor_wall.position.x = position.x + 7 * Global.tile_size
		hor_wall.position.y = position.y + 17 * Global.tile_size
		get_parent().add_child(hor_wall)


func _process(delta):
	if edges_node != null:
		for i in range(4):
			if get_parent().has_enemy("Enemy" + str(id) + str(i)):
				return
		end_battle()


func set_id(new_id):
	id = new_id


func set_type(new_type):
	type = new_type


func start_battle():
	edges_node = Node2D.new()
	get_parent().add_child(edges_node)
	await get_tree().create_timer(1.0).timeout
	if get_parent().has_edge(id, id - 1):
		var vert_wall = vertical_wall_preload.instantiate()
		vert_wall.name = "vw" + name + "0"
		vert_wall.position.x = position.x
		vert_wall.position.y = position.y + 5 * Global.tile_size
		edges_node.add_child(vert_wall)
	if get_parent().has_edge(id, id + 1):
		var vert_wall = vertical_wall_preload.instantiate()
		vert_wall.name = "vw" + name + "1"
		vert_wall.position.x = position.x + 19 * Global.tile_size
		vert_wall.position.y = position.y + 5 * Global.tile_size
		edges_node.add_child(vert_wall)
	if get_parent().has_edge(id, id - 3):
		var hor_wall = horizontal_wall_preload.instantiate()
		hor_wall.name = "hw" + name + "0"
		hor_wall.position.x = position.x + 7 * Global.tile_size
		hor_wall.position.y = position.y
		edges_node.add_child(hor_wall)
	if get_parent().has_edge(id, id + 3):
		var hor_wall = horizontal_wall_preload.instantiate()
		hor_wall.name = "hw" + name + "1"
		hor_wall.position.x = position.x + 7 * Global.tile_size
		hor_wall.position.y = position.y + 17 * Global.tile_size
		edges_node.add_child(hor_wall)
		var down_fix = down_fix_preload.instantiate()
		down_fix.name = "df" + name
		down_fix.position.x = position.x + 7 * Global.tile_size
		down_fix.position.y = position.y + 18 * Global.tile_size
		edges_node.add_child(down_fix)


func end_battle():
	get_parent().remove_child(edges_node)
	edges_node = null


func _on_player_detector_body_entered(body):
	if body.name == "Player":
		if type == "battle" and edges_node == null and get_parent().has_enemy("Enemy" + str(id) + "0"):
			start_battle()
			
