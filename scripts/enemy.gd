extends CharacterBody2D


@onready var navigation_agent = $NavigationAgent2D
const max_cord = 10000

var playerNextTo = false
var alive = true
var chase = false
var speed = 1
var hp = 100
var canDamage = true

var points_to_walk = Array()
var ind = 0
var last_global_position = global_position


func _ready():
	points_to_walk.append(Vector2(-max_cord, -max_cord))
	points_to_walk.append(Vector2(max_cord, -max_cord))
	points_to_walk.append(Vector2(-max_cord, max_cord))
	points_to_walk.append(Vector2(max_cord, max_cord))
	navigation_agent.set_target_position(points_to_walk[ind])


func _physics_process(delta):
	if alive:
		var player = get_parent().get_parent().get_player()
		
		if playerNextTo and player.is_alive() and canDamage:
			canDamage = false
			player.get_damaged(50)
			$EnemyTimer.start(1)
			get_parent().get_parent().update_hp()
		if not canDamage:
			$AnimatedSprite2D.play("attack")
		elif chase and player.is_alive():
			navigation_agent.set_target_position(player.get_global_position())
			
			if !(navigation_agent.is_target_reached()):
				var direction = (navigation_agent.get_next_path_position() - global_position).normalized()
				velocity = direction * speed
				move_and_collide(velocity)
				$AnimatedSprite2D.play("walk")
		else:
			var direction = (navigation_agent.get_next_path_position() - global_position).normalized()
			velocity = direction * speed
			move_and_collide(velocity)
			
			# gavnocode ON
			if last_global_position == global_position:
				$AnimatedSprite2D.play("idle")
			else:
				$AnimatedSprite2D.play("walk")
				last_global_position = global_position
			# gavnocode OFF


func set_chase():
	chase = true


func get_damaged(damage):
	hp -= damage
	set_healts_bar()
	
	if hp <= 0:
		if alive:
			get_parent().get_parent().remove_enemy(25 + 10 * Global.current_level)
		alive = false
		$AnimatedSprite2D.play("death")
		$CollisionShape2D.set_deferred("disabled", true)
		$HealthBar.hide()


func _on_is_damaged_body_entered(body):
	if body.get_name() == "Player":
		playerNextTo = true


func _on_is_damaged_body_exited(body):
	if body.get_name() == "Player":
		playerNextTo = false


func _on_enemy_timer_timeout():
	canDamage = true;


func set_healts_bar():
	$HealthBar.set_value(hp)


func add_max_health(add_hp):
	hp += add_hp
	$HealthBar.set_max(hp)
	set_healts_bar()


func is_alive():
	return alive


func _on_timer_timeout():
	if !(chase and get_parent().get_parent().get_player().is_alive()):
		ind += 1
		if ind == 4:
			ind = 0
			
		navigation_agent.set_target_position(points_to_walk[ind])
