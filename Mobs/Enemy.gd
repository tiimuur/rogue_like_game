extends CharacterBody2D

var playerNextTo = false
var alive = true
var chase = false
const speed = 0.7
var hp = 100
var canDamage = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if alive:
		velocity = Vector2()
		var player = $"../../Player"
		var direction = (player.position - self.position).normalized()
		if playerNextTo and player.alive:
			if canDamage:
				canDamage = false
				player.getDamaged(50)
				$EnemyTimer.start(1)
			
		
		if chase and player.alive:
			velocity = direction * speed
			$AnimatedSprite2D.play("walk")
		else:
			velocity = Vector2()
			$AnimatedSprite2D.play("idle")
		move_and_collide(velocity)
	
	
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		chase = true


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		chase = false
		
func getDamaged(damage):
	hp -= damage
	if hp <= 0:
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
