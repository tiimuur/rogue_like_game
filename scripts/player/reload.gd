extends Control


func _ready():
	$ReloadBar.set_max(30)
	$ReloadBar.hide()


func _on_reload_bar_value_changed(value):
	if value == 30:
		$ReloadBar.hide()
		$"..".set_reload(false)
		return
		
	$ReloadTimer.start(Global.time_between_reload_anim)


func _on_reload_timer_timeout():
	$ReloadBar.set_value($ReloadBar.get_value() + 1)
