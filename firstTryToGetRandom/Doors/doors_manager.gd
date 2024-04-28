extends Node2D

var closed_door_preload = preload("res://firstTryToGetRandom/Doors/closed_door.tscn")
var opened_door_preload = preload("res://firstTryToGetRandom/Doors/opened_door.tscn")
var opened = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var tilemap = closed_door_preload.instantiate()
	tilemap.name = "door"
	add_child(tilemap)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Open"):
		var player_position = get_parent().get_player().position
		if abs(position.x - player_position.x) < 100 and abs(position.y - player_position.y) < 100:
			remove_child($door)
			var tilemap
			if opened:
				tilemap = closed_door_preload.instantiate()
			else:
				tilemap = opened_door_preload.instantiate()
			tilemap.name = "door"
			add_child(tilemap)
			opened = not opened
