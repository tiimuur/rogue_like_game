extends CharacterBody2D

var speed = 1

func _process(delta):
	velocity = Vector2()
	var moving = false
	if Input.is_action_pressed("up"):
		velocity.y -= speed
		moving = true
	if Input.is_action_pressed("down"):
		velocity.y += speed
		moving = true
	if Input.is_action_pressed("left"):
		velocity.x -= speed
		moving = true
	if Input.is_action_pressed("right"):
		velocity.x += speed
		moving = true
	move_and_collide(velocity)
	if moving:
		$AnimatedSprite2D.play("moving")
	else:
		$AnimatedSprite2D.play("idle")
