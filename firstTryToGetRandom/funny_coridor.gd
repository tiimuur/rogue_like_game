extends Node2D

var arrayOfPreloads = [preload("res://firstTryToGetRandom/firstRoom321.tscn"),
 preload("res://firstTryToGetRandom/room1123.tscn")]
var funny_coridor = preload("res://firstTryToGetRandom/coridor.tscn")
var len_of_room = 20 * 16

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(5):
		var room = arrayOfPreloads[randi_range(0, 1)].instantiate()
		room.position.x = len_of_room * i
		room.position.y = -32  - len_of_room
		add_child(room)
	for i in range(5):
		var room = arrayOfPreloads[randi_range(0, 1)].instantiate()
		room.position.x = len_of_room * i
		room.position.y = 16 * 4
		add_child(room)
	for i in range(5):
		var room = funny_coridor.instantiate()
		room.position.x = len_of_room * i
		room.position.y = 0
		add_child(room)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
