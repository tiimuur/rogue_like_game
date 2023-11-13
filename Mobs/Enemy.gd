extends CharacterBody2D

var chase = false
var speed = 0.7

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2()
	var player = $"../Player"#
	var direction = (player.position - self.position).normalized()
	if chase:
		velocity.x = direction.x * speed
		velocity.y = direction.y * speed
		$AnimatedSprite2D.play("walk")
	else:
		velocity.x = 0
		velocity.y = 0
		$AnimatedSprite2D.play("idle")
	move_and_collide(velocity)
		
	
	
		

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		chase = true


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		chase = false
