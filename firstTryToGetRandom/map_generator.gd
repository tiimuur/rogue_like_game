extends Node2D


var enemy_count = 0
var dsu_parent = []
var room_coord = {}
var enemies = {}
var graph = []
var room_preload = preload("res://firstTryToGetRandom/test_room.tscn")
var enemy_preload = preload("res://Mobs/Enemy.tscn")
var vert_coridor_preload = preload("res://firstTryToGetRandom/vertical_coridor.tscn")
var hor_coridor_preload = preload("res://firstTryToGetRandom/horizontal_coridor.tscn")
var player_preload = preload("res://MainPerson/character_body_2d.tscn")
var greeting_preload = preload("res://firstTryToGetRandom/greeting.tscn")


func dsu_init(size):
	for i in range(size):
		dsu_parent.append(i)


func dsu_find(x):
	if dsu_parent[x] == x:
		return x
	else:
		dsu_parent[x] = dsu_find(dsu_parent[x])
		return dsu_parent[x]


func dsu_unite(a, b):
	a = dsu_find(a)
	b = dsu_find(b)
	dsu_parent[a] = b


func make_enemy(posx, posy, id):
	var enemy = enemy_preload.instantiate()
	enemy.position = Vector2(posx, posy)
	enemy.name = id
	add_child(enemy)
	enemy_count += 1
	enemy.add_max_health(20 * Global.current_level)
	enemies[id] = null


func get_bullets():
	return $Bullets


func get_player():
	return $Player


func get_current_hp():
	return get_player().hp


func get_info_layer():
	return $Info


func get_hp_label():
	return get_info_layer().get_child(0)


func get_money_label():
	return get_info_layer().get_child(1)


func update_hp():
	get_hp_label().text = "HP: " + str(get_current_hp()) + "/" + str(Global.max_hp)


func update_money(change):
	Global.current_money += change
	get_money_label().text = "Money: " + str(Global.current_money)


func remove_enemy(money_change, enemy_name):
	update_money(money_change)
	enemy_count -= 1
	enemies.erase(enemy_name)


func has_enemy(enemy_name):
	return enemy_name in enemies


func has_room(room_id):
	return room_id in room_coord


func has_edge(from, to):
	return to in graph[from]


func _ready():
	Global.current_level += 1
	dsu_init(9)
	var all_edges = []
	var edges = []
	var rooms = []
	
	for i in range(9):
		graph.append(Dictionary())
	
	for i in range(9):
		var y_coord = i / 3
		var x_coord = i % 3
		if x_coord != 2:
			all_edges.append([i, i + 1])
		if y_coord != 2:
			all_edges.append([i, i + 3])
			
	all_edges.shuffle()
	
	while dsu_find(0) != dsu_find(8):
		edges.append(all_edges.back())
		all_edges.pop_back()
		dsu_unite(edges.back()[0], edges.back()[1])
		graph[edges.back()[0]][edges.back()[1]] = null
		graph[edges.back()[1]][edges.back()[0]] = null
	
	for i in range(9):
		if dsu_find(i) == dsu_find(0):
			rooms.append([i, "battle"])
			if i == 0:
				rooms.back()[1] = "start"
			elif i == 8:
				rooms.back()[1] = "finish"
	
	for room in rooms:
		var y_coord = room[0] / 3
		var x_coord = room[0] % 3
		var new_room = room_preload.instantiate()
		new_room.name = "r" + str(room[0])
		new_room.position.x = x_coord * Global.tile_size * 30
		new_room.position.y = y_coord * Global.tile_size * 30
		room_coord[room[0]] = new_room.position
		new_room.set_id(room[0])
		new_room.set_type(room[1])
		add_child(new_room)
		
		if room[1] == "battle":
			make_enemy(new_room.position.x + 5 * Global.tile_size, 
			new_room.position.y + 5 * Global.tile_size, "Enemy" + str(room[0]) + "0")
			make_enemy(new_room.position.x + 5 * Global.tile_size, 
			new_room.position.y + 15 * Global.tile_size, "Enemy" + str(room[0]) + "1")
			make_enemy(new_room.position.x + 15 * Global.tile_size, 
			new_room.position.y + 5 * Global.tile_size, "Enemy" + str(room[0]) + "2")
			make_enemy(new_room.position.x + 15 * Global.tile_size, 
			new_room.position.y + 15 * Global.tile_size, "Enemy" + str(room[0]) + "3")
	
	for edge in edges:
		var new_edge
		if dsu_find(edge[0]) == dsu_find(0):
			if edge[1] - edge[0] == 3:
				new_edge = vert_coridor_preload.instantiate()
				new_edge.name = "1e" + str(edge[0])
				new_edge.position.x = room_coord[edge[0]].x + 8 * Global.tile_size
				new_edge.position.y = room_coord[edge[0]].y + 20 * Global.tile_size
			else:
				new_edge = hor_coridor_preload.instantiate()
				new_edge.name = "0e" + str(edge[0])
				new_edge.position.x = room_coord[edge[0]].x + 20 * Global.tile_size
				new_edge.position.y = room_coord[edge[0]].y + 8 * Global.tile_size
			add_child(new_edge)
		
	var player = player_preload.instantiate()
	player.position.x = room_coord[0].x + 10 * Global.tile_size
	player.position.y = room_coord[0].y + 10 * Global.tile_size
	player.name = "Player"
	player.hp = Global.current_hp
	add_child(player)
	
	var bullets_node = Node2D.new()
	bullets_node.name = "Bullets";
	add_child(bullets_node)
	
	var info_layer = CanvasLayer.new()
	info_layer.name = "Info"
	add_child(info_layer)
	
	var hp_label = Label.new()
	hp_label.text = "HP: " + str(get_current_hp()) + "/" + str(Global.max_hp)
	get_info_layer().add_child(hp_label)
	
	var money_label = Label.new()
	money_label.text = "Money: " + str(Global.current_money)
	money_label.position.y = 30
	get_info_layer().add_child(money_label)
	
	var greeting = greeting_preload.instantiate()
	get_info_layer().add_child(greeting)


func _process(delta):
	if enemy_count == 0:
		Global.current_hp = get_player().hp
		get_tree().change_scene_to_file("res://firstTryToGetRandom/hub.tscn")
