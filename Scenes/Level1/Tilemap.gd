extends Node2D

var enemyPreload = preload("res://Mobs/Enemy.tscn")
var canSpawn = true
var cnt = 0



func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if canSpawn:
		enemy_spawn()
		canSpawn = false
		$Mobs/SpawnTimer.start(5)
	
	
	
func enemy_spawn():
	var enemy = enemyPreload.instantiate()
	enemy.name = "Enemy" + str(cnt)
	cnt += 1
	enemy.position = $Mobs/SpawnPosition.global_position
	$Mobs.add_child(enemy)


func _on_spawn_timer_timeout():
	canSpawn = true


func get_player():
	return $Player


func get_tilemap():
	return $TileMap
