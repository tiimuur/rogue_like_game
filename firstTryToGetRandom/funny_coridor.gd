extends Node2D

var arrayOfPreloadsUp = [preload("res://firstTryToGetRandom/room_01_up.tscn"),
 preload("res://firstTryToGetRandom/room_02_up.tscn")]
var arrayOfPreloadsDown = [preload("res://firstTryToGetRandom/room_01_down.tscn"),
 preload("res://firstTryToGetRandom/room_02_down.tscn")]
var funny_coridor = preload("res://firstTryToGetRandom/coridor.tscn")
var first_coridor_piece = preload("res://firstTryToGetRandom/firstCoridor.tscn")
var last_coridor_piece = preload("res://firstTryToGetRandom/lastCoridor.tscn")
var characterPreload = preload("res://MainPerson/character_body_2d.tscn")
var len_of_room = 20 * 16
var doors_preload_up = preload("res://firstTryToGetRandom/Doors/door_up/doors_manager.tscn")
var doors_preload_down = preload("res://firstTryToGetRandom/Doors/door_up/doors_manager.tscn")
var enemy_preload = preload("res://Mobs/Enemy.tscn")

var enemy_count = 0

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
	enemy_count -= 1
	get_money_label().text = "Money: " + str(Global.current_money)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.current_level += 1
	
	for i in range(5):
		var coridor
		if i == 0:
			coridor = first_coridor_piece.instantiate()
		elif i == 4:
			coridor = last_coridor_piece.instantiate()
		else:
			coridor = funny_coridor.instantiate()
		coridor.position.x = len_of_room * i
		coridor.position.y = 0
		add_child(coridor)
		
	var enemy = enemy_preload.instantiate()
	enemy.position.x = 256
	enemy.position.y = 32
	init_enemy(enemy, -1)
	
	for i in range(5):
		var room = arrayOfPreloadsUp[randi_range(0, 1)].instantiate()
		room.position.x = len_of_room * i
		room.position.y = -32  - len_of_room
		add_child(room)
		
	for i in range(5):
		enemy = enemy_preload.instantiate()
		enemy.position.x = len_of_room * i + len_of_room / 2 - 16 - 64
		enemy.position.y = -200
		init_enemy(enemy, i)
	
	for i in range(5):
		var room = arrayOfPreloadsDown[randi_range(0, 1)].instantiate()
		room.position.x = len_of_room * i
		room.position.y = 16 * 4
		add_child(room)
		
	for i in range(5):
		enemy = enemy_preload.instantiate()
		enemy.position.x = len_of_room * i + len_of_room / 2 - 16
		enemy.position.y = 300
		init_enemy(enemy, i + 5)
		
	var character = characterPreload.instantiate()
	character.position.x = 50
	character.position.y = 20
	character.name = "Player"
	character.hp = Global.current_hp
	add_child(character)
	
	var bulletsNode = Node2D.new()
	bulletsNode.name = "Bullets";
	add_child(bulletsNode)
	
	for i in range(5):
		var doors = doors_preload_up.instantiate()
		doors.position.x = len_of_room * i + len_of_room / 2 - 16
		doors.position.y = -48
		add_child(doors)
		
	for i in range(5):
		var doors = doors_preload_up.instantiate()
		doors.position.x = len_of_room * i + len_of_room / 2 - 16
		doors.position.y = 64
		add_child(doors)
	
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enemy_count == 0:
		Global.current_hp = get_player().hp
		get_tree().change_scene_to_file("res://firstTryToGetRandom/hub.tscn")
		

func init_enemy(enemy, id):
	enemy.name = "Enemy" + str(id)
	add_child(enemy)
	enemy_count += 1
	enemy.add_max_health(20 * Global.current_level)
