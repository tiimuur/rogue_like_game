extends CharacterBody2D

var speed = 1

func _process(delta):
	velocity = Vector2()
	var moving = false
	var cur_speed = speed
	if Input.is_action_pressed("Run"):
		cur_speed *= 2
	if Input.is_action_pressed("up"):
		velocity.y -= cur_speed
		moving = true
	if Input.is_action_pressed("down"):
		velocity.y += cur_speed
		moving = true
	if Input.is_action_pressed("left"):
		velocity.x -= cur_speed
		moving = true
	if Input.is_action_pressed("right"):
		velocity.x += cur_speed
		moving = true
	move_and_collide(velocity)
	if moving:
		$AnimatedSprite2D.play("moving")
	else:
		$AnimatedSprite2D.play("idle")
