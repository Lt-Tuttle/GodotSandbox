class_name AnimationComponent
extends Node

func HandleAnimation(animation: AnimationPlayer, input: InputComponent, sprite: Sprite2D, _delta: float):
	var dir = input.move_vector
	
	if dir == Vector2.ZERO:
		var last_dir = input.last_move_direction
		if last_dir.x != 0:
			animation.play("IdleSide")
		elif last_dir.y > 0:
			animation.play("IdleDown")
		else:
			animation.play("IdleUp")
		return
		
	# Simple checks based on the already locked vector
	if dir.x != 0:
		animation.play("RunSide")
		sprite.flip_h = dir.x < 0
	elif dir.y != 0:
		if dir.y > 0:
			animation.play("RunDown")
		else:
			animation.play("RunUp")
