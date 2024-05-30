extends Control


func update_info():
	$InfoLabel.set_text("💲" + str(Global.current_money) + "\n❤️" \
	 + str(Global.current_hp) + "/" + str(Global.max_hp))


func _ready():
	$Panel.set_size(get_viewport().get_size())
	var label_size = Vector2($Panel.get_size().x, 50)
	update_info()
	$InfoLabel.set_size(label_size)
	$WorkshopLabel.set_size(label_size)
	
	$ContinueBox.set_size(Vector2(label_size.x / 2, label_size.y * 2))
	$ContinueBox.set_position(Vector2(0.25 * label_size.x, $Panel.get_size().y - 3 * label_size.y))
	$ContinueBox/PlayButton.set_text("Go to level " + str(Global.current_level + 1 + 1))
	
	$ShopBox.set_position(Vector2(0.25 * label_size.x, $InfoLabel.get_position().y + 300))
	$ShopBox.set_size(Vector2(label_size.x / 2, label_size.y * 4))


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/map.tscn")


func _on_quit_to_main_menu_button_pressed():
	Global.current_level = 0
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_heal_full_button_pressed():
	if Global.current_money >= 50:
		Global.current_money -= 50
		Global.current_hp += 50
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


func _on_increase_magazine_button_pressed():
	if Global.current_money >= 100:
		Global.current_money -= 100
		Global.ammo_size += 1
		update_info()


func _on_decrease_reload_time_button_pressed():
	if Global.current_money >= 100:
		Global.current_money -= 100
		Global.time_between_reload_anim -= 0.01
		update_info()


func _on_increase_stamina_button_pressed():
	if Global.current_money >= 150:
		Global.current_money -= 150
		Global.max_stamina += 100
		update_info()
