extends CharacterBody2D

export var speed = 100
var velocity = Vector2.ZERO
var direction = Vector2.ZERO

func movement():
	velocity = Vector2.ZERO
	direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	velocity = direction.normalized() * speed
	velocity = move_and_slide(velocity)
	
	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("moving")
	
func _physics_process(delta):
	movement()
