extends ProgressBar


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = $"../../Player".hp / 2
	

