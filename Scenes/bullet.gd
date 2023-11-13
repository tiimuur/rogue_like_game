extends Area2D

const SPEED = 500
var velocity = Vector2()
var track_angel = 0

func set_ta(x):
	track_angel = x
	rotation = x


func _physics_process(delta):
	var dist = SPEED * delta
	velocity.x = dist * cos(track_angel)
	velocity.y = dist * sin(track_angel)
	translate(velocity)
	

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()



func _on_body_entered(body):
	if body.name != "Player":
		queue_free()
