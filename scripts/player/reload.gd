extends Control

const TIME_BETWEEN_ANIM_CHANGED = 0.1


func _ready():
	$ReloadBar.set_max(30)
	$ReloadBar.hide()


func _on_reload_bar_value_changed(value):
	if value == 30:
		$ReloadBar.hide()
		$"..".set_reload(false)
		return
		
	$ReloadTimer.start(TIME_BETWEEN_ANIM_CHANGED)


func _on_reload_timer_timeout():
	$ReloadBar.set_value($ReloadBar.get_value() + 1)
