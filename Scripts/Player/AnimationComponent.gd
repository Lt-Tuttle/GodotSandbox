class_name AnimationComponent
extends Node

func HandleAnimation(animation: AnimationPlayer, input: InputComponent, sprite: Sprite2D, _delta: float):
	var dir = input.move_vector
	
	if dir == Vector2.ZERO:
		return # Or play("Idle")
		
	# Simple checks based on the already locked vector
	if dir.x != 0:
		animation.play("IdleSide")
		sprite.flip_h = dir.x < 0
	elif dir.y != 0:
		if dir.y > 0:
			animation.play("IdleDown")
		else:
			animation.play("IdleUp")
