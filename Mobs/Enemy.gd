extends CharacterBody2D

var chase = false
var speed = 0.7

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2()
	var player = $"../Player"
	var direction = (player.position - self.position).normalized()
	velocity.x = direction.x * speed
	velocity.y = direction.y * speed
	$AnimatedSprite2D.play("walk")
	#if chase:
		
	
	move_and_collide(velocity)
		

#func _on_area_2d_body_entered(body):
#	if body.name = "player"
#		chase = true 
