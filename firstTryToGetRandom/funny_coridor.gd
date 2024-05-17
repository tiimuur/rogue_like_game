extends Node2D

var arrayOfPreloadsUp = [preload("res://firstTryToGetRandom/room_01_up.tscn"),
 preload("res://firstTryToGetRandom/room_02_up.tscn")]
var arrayOfPreloadsDown = [preload("res://firstTryToGetRandom/room_01_down.tscn"),
 preload("res://firstTryToGetRandom/room_02_down.tscn")]
var funny_coridor = preload("res://firstTryToGetRandom/coridor.tscn")
var characterPreload = preload("res://MainPerson/character_body_2d.tscn")
var len_of_room = 20 * 16
var doors_preload_up = preload("res://firstTryToGetRandom/Doors/door_up/doors_manager.tscn")
var doors_preload_down = preload("res://firstTryToGetRandom/Doors/door_up/doors_manager.tscn")
var enemy_preload = preload("res://Mobs/Enemy.tscn")
var heal_button_preload = preload("res://firstTryToGetRandom/heal_button.tscn")

var maxHP = 200
var money = 0


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
	get_hp_label().text = "HP: " + str(get_current_hp()) + "/" + str(maxHP)
	

func update_money(change):
	money += change
	get_money_label().text = "Money: " + str(money)
	

func heal():
	if money >= 50:
		get_player().hp = maxHP
		update_hp()
		update_money(-50)

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(5):
		var coridor = funny_coridor.instantiate()
		coridor.position.x = len_of_room * i
		coridor.position.y = 0
		add_child(coridor)
	
	for i in range(5):
		var room = arrayOfPreloadsUp[randi_range(0, 1)].instantiate()
		room.position.x = len_of_room * i
		room.position.y = -32  - len_of_room
		add_child(room)
	
	for i in range(5):
		var room = arrayOfPreloadsDown[randi_range(0, 1)].instantiate()
		room.position.x = len_of_room * i
		room.position.y = 16 * 4
		add_child(room)
	
	for i in range(5):
		var enemy = enemy_preload.instantiate()
		enemy.position.x = len_of_room * i + len_of_room / 2 - 16
		enemy.position.y = -200
		enemy.name = "Enemy" + str(i)
		add_child(enemy)
		
	var character = characterPreload.instantiate()
	character.position.x = 0
	character.position.y = 0
	character.name = "Player"
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
	hp_label.text = "HP: " + str(get_current_hp()) + "/" + str(maxHP)
	get_info_layer().add_child(hp_label)
	
	var money_label = Label.new()
	money_label.text = "Money: 0"
	money_label.position.y = 30
	get_info_layer().add_child(money_label)
	
	var heal_button = heal_button_preload.instantiate()
	heal_button.position.y = 60
	get_info_layer().add_child(heal_button)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
