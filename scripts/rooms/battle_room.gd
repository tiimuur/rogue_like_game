extends BaseRoom
class_name BattleRoom


var battle_now = false
var enemies = []


func all_enemies_dead():
	for enemy in enemies:
		if enemy.is_alive():
			return false
	return true


func init_enemies():
	for node in get_children():
		if node.get_name() == "Enemy":
			node.set_name("Enemy" + str(id) + str(len(enemies)))
			node.add_max_health(20 * Global.current_level)
			enemies.append(node)


func start_battle():
	battle_now = true
	fill_holes(false)
	for enemy in enemies:
		enemy.set_chase()


func end_battle():
	battle_now = false
	delete_dynamic_walls()


func _ready():
	prepare_walls()
	init_enemies()


func _process(delta):
	if player_here:
		if not battle_now and not all_enemies_dead():
			await get_tree().create_timer(1.0).timeout
			if player_here and not battle_now:
				battle_now = true
				start_battle()
		elif battle_now and all_enemies_dead():
			end_battle()
