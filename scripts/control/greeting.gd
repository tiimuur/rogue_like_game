extends Label


func _ready():
	text = "Welcome to level " + str(Global.current_level + 1)
	visible_ratio = 0.0


func _process(delta):
	while visible_ratio < 1.0:
		await get_tree().create_timer(0.05).timeout
		visible_ratio += 0.1
	await get_tree().create_timer(2.0).timeout
	while visible_ratio > 0.0:
		await get_tree().create_timer(0.05).timeout
		visible_ratio -= 0.1
	hide()
