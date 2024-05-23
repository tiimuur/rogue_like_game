extends Control

const TIME_BETWEEN_ANIM_CHANGED = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	$ReloadBar.max_value = 30
	$ReloadBar.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_reload_bar_value_changed(value):
	print(value)
	if value == 30:
		$ReloadBar.hide()
		$"..".reloading = false
		return
		
	$ReloadTimer.start(TIME_BETWEEN_ANIM_CHANGED)


func _on_reload_timer_timeout():
	$ReloadBar.value += 1
