extends Control

func update_info():
	$InfoLabel.text = "Money: " + str(Global.current_money) + "\nHP: " \
	 + str(Global.current_hp) + "/" + str(Global.max_hp)


# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel.size = get_viewport().size
	
	var label_size = Vector2($Panel.size.x, 50)
	
	update_info()
	$InfoLabel.size = label_size
	
	$WorkshopLabel.size = label_size
	
	$ContinueBox.size = Vector2(label_size.x / 2, label_size.y * 2)
	$ContinueBox.position = Vector2(0.25 * label_size.x, $Panel.size.y - 3 * label_size.y)
	$ContinueBox/PlayButton.text = "Go to level " + str(Global.current_level + 1 + 1)
	
	$ShopBox.position = Vector2(0.25 * label_size.x, $InfoLabel.position.y + 300)
	$ShopBox.size = Vector2(label_size.x / 2, label_size.y * 4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://firstTryToGetRandom/map.tscn")


func _on_quit_to_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_heal_full_button_pressed():
	if Global.current_money >= 50:
		Global.current_money -= 50
		Global.current_hp = Global.max_hp
		update_info()


func _on_increase_max_hp_button_pressed():
	if (Global.current_money >= 100):
		Global.max_hp += 100
		Global.current_money -= 100
		update_info()


func _on_increase_damage_button_pressed():
	if Global.current_money >= 100:
		Global.current_money -= 100
		Global.bullet_dmg += 20
		update_info()
