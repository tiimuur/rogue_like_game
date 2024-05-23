extends CharacterBody2D

@onready var navigation_agent : NavigationAgent2D = $NavigationAgent2D

var playerNextTo = false
var alive = true
var chase = false
const speed = 1
var hp = 100
var canDamage = true

func _ready():
	pass
	#$HealthBar.max_value = hp
	#set_healts_bar()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if alive:
		var player = get_parent().get_player()
		
		if playerNextTo and player.alive and canDamage:
			canDamage = false
			player.getDamaged(50)
			$EnemyTimer.start(1)
			get_parent().update_hp()
		if not canDamage:
			$AnimatedSprite2D.play("attack")
		elif chase and player.alive:
			navigation_agent.target_position = player.global_position
			
			if !(navigation_agent.is_target_reached()):# and navigation_agent.is_target_reachable():
				var direction = (navigation_agent.get_next_path_position() - self.global_position).normalized()
				velocity = direction * speed
				move_and_collide(velocity)
				$AnimatedSprite2D.play("walk")
		else:
			$AnimatedSprite2D.play("idle")

	
	
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		chase = true


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		chase = false
		
func getDamaged(damage):
	hp -= damage
	set_healts_bar()
	
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
	
func set_healts_bar():
	$HealthBar.value = hp
	
func add_max_health(add_hp):
	hp += add_hp
	$HealthBar.max_value = hp
	set_healts_bar()
