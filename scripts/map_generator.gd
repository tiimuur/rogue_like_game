extends Node2D


var enemy_count = 0
var dsu_parent = []
var room_coord = {}
var enemies = {}
var graph = []

var battle_room_preload = [preload("res://scenes/rooms/battle_room1.tscn"), 
	preload("res://scenes/rooms/battle_room2.tscn"), 
	preload("res://scenes/rooms/battle_room3.tscn")
]
var start_room_preload = [preload("res://scenes/rooms/test_room.tscn")]
var enemy_preload = preload("res://scenes/Enemy.tscn")
var vertical_coridor_preload = preload("res://scenes/rooms/vertical_coridor.tscn")
var horizontal_coridor_preload = preload("res://scenes/rooms/horizontal_coridor.tscn")
var player_preload = preload("res://scenes/player/player.tscn")
var greeting_preload = preload("res://scenes/control/greeting.tscn")


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
	get_money_label().set_text("Money: " + str(Global.current_money))


func remove_enemy(money_change, enemy_name):
	update_money(money_change)


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
			rooms.append(i)
	
	for room in rooms:
		var y_coord = room / 3
		var x_coord = room % 3
		var new_room = battle_room_preload.pick_random().instantiate()
		new_room.set_position(Vector2(
			x_coord * Global.sum_size, 
			y_coord * Global.sum_size
		))
		new_room.set_id(room)
		room_coord[room] = new_room.get_position()
		add_child(new_room)
	
	for edge in edges:
		var new_edge
		if dsu_find(edge[0]) == dsu_find(0):
			if edge[1] - edge[0] == 3:
				new_edge = vertical_coridor_preload.instantiate()
				new_edge.set_position(Vector2(
					room_coord[edge[0]].x + (Global.room_size - Global.hole_size) / 2, 
					room_coord[edge[0]].y + Global.room_size
				))
			else:
				new_edge = horizontal_coridor_preload.instantiate()
				new_edge.set_position(Vector2(
					room_coord[edge[0]].x + Global.room_size, 
					room_coord[edge[0]].y + (Global.room_size - Global.hole_size) / 2
				))
			add_child(new_edge)
		
	var player = player_preload.instantiate()
	player.set_position(Vector2(
		room_coord[0].x + Global.room_size / 2, 
		room_coord[0].y + Global.room_size / 2
	))
	player.set_name("Player")
	player.set_hp(Global.current_hp)
	add_child(player)
	
	var bullets_node = Node2D.new()
	bullets_node.set_name("Bullets")
	add_child(bullets_node)
	
	var info_layer = CanvasLayer.new()
	info_layer.name = "Info"
	add_child(info_layer)
	
	var hp_label = Label.new()
	hp_label.set_text("HP: " + str(get_current_hp()) + "/" + str(Global.max_hp))
	get_info_layer().add_child(hp_label)
	
	var money_label = Label.new()
	money_label.set_text("Money: " + str(Global.current_money))
	money_label.set_position(Vector2(0, 30))
	get_info_layer().add_child(money_label)
	
	var greeting = greeting_preload.instantiate()
	get_info_layer().add_child(greeting)
