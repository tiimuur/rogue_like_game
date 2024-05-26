extends Control


const TIME_FOR_STAMINA = 0.1


func _ready():
	$StaminaBar.set_max(100)
	$StaminaBar.set_value(100)


func _on_stamina_bar_value_changed(value):
	if $StaminaBar.get_value() == 100:
		return
		
	if $StaminaTimer.is_stopped():
		$StaminaTimer.start(TIME_FOR_STAMINA)


func _on_stamina_timer_timeout():
	$StaminaBar.set_value($StaminaBar.get_value() + 1)
