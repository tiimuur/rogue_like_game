extends CharacterBody2D

@onready var nav = $NavigationAgent2D

const TIME_FOR_SHOOTING = 1

var alive = true
var hp = 200
var speed = 0.7
var can_damage = true
var curent_max_clip = 5
var bullet_clip = curent_max_clip
var reloading = false

const bullet_preload = preload("res://scenes/player/bullet.tscn")


func is_alive():
	return alive


func set_hp(value):
	hp = value


func set_reload(value):
	reloading = value


func shooting_player():
	if alive and can_damage and not reloading:
		var bullet = bullet_preload.instantiate()
		bullet.set_position($Marker2D.get_global_position())
		bullet.set_ta(get_angle_to(get_global_mouse_position()))
		get_parent().get_bullets().add_child(bullet)
		$AnimatedSprite2D.play("shooting")
		can_damage = false
		
		bullet_clip -= 1
		if bullet_clip == 0:
			reload()
		else:
			$TimerForShoting.start(TIME_FOR_SHOOTING)


func get_damaged(damage):
	hp -= damage
	if hp <= 0:
		alive = false
		$AnimatedSprite2D.play("death")
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func reload():
	if alive and bullet_clip != curent_max_clip and not reloading:
		reloading = true
		$ReloadNode/ReloadBar.show()
		$ReloadNode/ReloadBar.set_value(1)
		bullet_clip = curent_max_clip


func get_player():
	return $Player


func get_tilemap():
	return $TileMap

func get_bullets():
	return $Bullets


func _on_timer_for_shoting_timeout():
	can_damage = true


func _process(delta):
	if !alive:
		return

	var moving = false
	var cur_speed = speed
	if Input.is_action_pressed("Run"):	
		cur_speed *= 1.5
	velocity = Input.get_vector("left", "right", "up", "down").normalized() * cur_speed
	
	if velocity.x != 0:
		$AnimatedSprite2D.set_flip_h(velocity.x < 0) 
	
	
	if not velocity.is_zero_approx():
		moving = true
		
	move_and_collide(velocity)


	if moving:
		$AnimatedSprite2D.play("moving")
	elif $AnimatedSprite2D.get_animation() == "moving" or not $AnimatedSprite2D.is_playing():
		$AnimatedSprite2D.play("idle")
		
	if Input.is_action_just_pressed("shoot"):
		shooting_player()
	
	if Input.is_action_just_pressed("Reload"):
		reload()
