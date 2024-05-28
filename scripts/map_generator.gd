extends Node2D


var dsu_parent = []
var room_coord = {}
var enemies = {}
var graph = []
var render_greeting = true
var pause_menu

const battle_room_preload = [
	preload("res://scenes/rooms/battle_room1.tscn"), 
	preload("res://scenes/rooms/battle_room2.tscn"), 
	preload("res://scenes/rooms/battle_room3.tscn"),
	preload("res://scenes/rooms/battle_room4.tscn")
]
const start_room_preload = preload("res://scenes/rooms/start_room.tscn")
const end_room_preload = preload("res://scenes/rooms/end_room.tscn")
const enemy_preload = preload("res://scenes/enemy.tscn")
const vertical_coridor_preload = preload("res://scenes/rooms/vertical_coridor.tscn")
const horizontal_coridor_preload = preload("res://scenes/rooms/horizontal_coridor.tscn")
const player_preload = preload("res://scenes/player/player.tscn")
const greeting_preload = preload("res://scenes/control/greeting.tscn")
const pause_menu_preload = preload("res://scenes/control/pause_manager.tscn")


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


func pause_game():
	get_tree().set_pause(true)
	pause_menu.show()


func resume_game():
	pause_menu.hide()
	get_tree().set_pause(false)


func quit_game():
	get_tree().set_pause(false)
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func set_greeting_rendered():
	render_greeting = false


func get_bullets():
	return $Bullets


func get_player():
	return $Player


func get_info_layer():
	return $Info


func get_hp_label():
	return get_info_layer().get_child(0)


func get_money_label():
	return get_info_layer().get_child(1)


func update_hp():
	get_hp_label().text = "❤️" + str(Global.current_hp) + "/" + str(Global.max_hp)


func update_money(change):
	Global.current_money += change
	get_money_label().set_text("💲" + str(Global.current_money))


func remove_enemy(money_change):
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
	
	graph[8][9] = null
	graph[8][11] = null
	
	for i in range(9):
		if dsu_find(i) == dsu_find(0):
			rooms.append(i)
	
	for room in rooms:
		var y_coord = room / 3
		var x_coord = room % 3
		var new_room
		if room == 0:
			new_room = start_room_preload.instantiate()
		elif room == 8:
			new_room = end_room_preload.instantiate()
		else:
			new_room = battle_room_preload.pick_random().instantiate()
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
	player.set_hp(Global.current_hp)
	add_child(player)
	
	var bullets_node = Node2D.new()
	bullets_node.set_name("Bullets")
	add_child(bullets_node)
	
	var info_layer = CanvasLayer.new()
	info_layer.set_name("Info")
	add_child(info_layer)
	
	var hp_label = Label.new()
	hp_label.set_text("❤️" + str(Global.current_hp) + "/" + str(Global.max_hp))
	hp_label.add_theme_font_size_override("font_size", 30)
	get_info_layer().add_child(hp_label)
	
	var money_label = Label.new()
	money_label.set_text("💲" + str(Global.current_money))
	money_label.set_position(Vector2(0, 50))
	money_label.add_theme_font_size_override("font_size", 30)
	get_info_layer().add_child(money_label)
	
	var greeting = greeting_preload.instantiate()
	get_info_layer().add_child(greeting)
	
	pause_menu = pause_menu_preload.instantiate()
	get_info_layer().add_child(pause_menu)


func _process(delta):
	if Input.is_action_just_pressed("Escape") and not render_greeting:
		if get_tree().is_paused():
			resume_game()
		else:
			pause_game()
