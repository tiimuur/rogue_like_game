extends CharacterBody2D

var track_angle = 0

func ta_set(x):
	track_angle = x
	rotation = x
	
func _process(delta):
	
	move_and_collide(Vector2().rotated(track_angle))
