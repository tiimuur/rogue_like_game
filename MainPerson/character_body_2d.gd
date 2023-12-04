extends CharacterBody2D

var hp = 200
var speed = 1
const BULLET = preload("res://Scenes/bullet.tscn")
 

func _process(delta):
	velocity = Vector2()
	var moving = false
	var cur_speed = speed
	
	#moving
	if Input.is_action_pressed("Run"):	
		cur_speed *= 2
	if Input.is_action_pressed("up"):
		velocity.y -= cur_speed
		moving = true
	if Input.is_action_pressed("down"):
		velocity.y += cur_speed
		moving = true
	if Input.is_action_pressed("left"):
		$AnimatedSprite2D.flip_h = true
		velocity.x -= cur_speed
		moving = true
	if Input.is_action_pressed("right"):
		$AnimatedSprite2D.flip_h = false
		velocity.x += cur_speed
		moving = true
		
	move_and_collide(velocity)
	
	
	if moving:
		$AnimatedSprite2D.play("moving")
	else:
		$AnimatedSprite2D.play("idle")
		
		
		
	if Input.is_action_just_pressed('shoot'):
		shooting_player()
	
		
		
func shooting_player():
	var bullet = BULLET.instantiate()
	bullet.position = $Marker2D.global_position
	bullet.set_ta(get_angle_to(get_global_mouse_position()))
	get_parent().add_child(bullet)
