extends CharacterBody2D

@onready var navigation_agent : NavigationAgent2D = $NavigationAgent2D

var playerNextTo = false
var alive = true
var chase = false
const speed = 0.7
var hp = 100
var canDamage = true


func _physics_process(delta):
	if alive:
		var player = get_parent().get_player()
		
		if playerNextTo and player.alive and canDamage:
			canDamage = false
			player.getDamaged(50)
			$EnemyTimer.start(1)
			get_parent().update_hp()
			
		elif chase and player.alive:
			navigation_agent.target_position = player.global_position
			if !(navigation_agent.is_target_reached()):
				var direction = (navigation_agent.get_next_path_position() - self.global_position).normalized()
				velocity = direction * speed
				move_and_collide(velocity)
			$AnimatedSprite2D.play("walk")
			
		else:
			velocity = Vector2()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if alive:
		velocity = Vector2()
		var player = get_parent().get_player()
		#var direction = (player.position - self.position).normalized()
		if playerNextTo and player.alive:
			if canDamage:
				canDamage = false
				player.getDamaged(50)
				$EnemyTimer.start(1)
				get_parent().update_hp()
			
		if not canDamage:
			$AnimatedSprite2D.play("attack")
		elif chase and player.alive:
			navigation_agent.target_position = Vector2(16, 16)
			$AnimatedSprite2D.play("walk")
		else:
			velocity = Vector2()
			$AnimatedSprite2D.play("idle")
		#move_and_collide(velocity)
	
	
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		chase = true


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		chase = false
		
func getDamaged(damage):
	hp -= damage
	if hp <= 0:
		if alive:
			get_parent().update_money(25)
		alive = false
		$AnimatedSprite2D.play("death")
		$CollisionShape2D.set_deferred("disabled", true)


func _on_is_damaged_body_entered(body):
	if body.name == "Player":
		playerNextTo = true
		


func _on_is_damaged_body_exited(body):
	if body.name == "Player":
		playerNextTo = false


func _on_enemy_timer_timeout():
	canDamage = true;
