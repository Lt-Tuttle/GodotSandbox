class_name AnimationComponent
extends Node

func HandleAnimation(animation: AnimationPlayer, input: InputComponent, sprite: Sprite2D, body: CharacterBody2D):
	var dir = input.input_horizontal
	
	# Handle flipping
	if dir != 0:
		sprite.flip_h = dir < 0
	
	# Handle Animations
	if body.is_on_floor():
		if dir != 0:
			animation.play("Run")
		else:
			animation.play("Idle")
	else:
		if body.velocity.y < 0:
			if body.velocity.y > -100: # Near peak
				animation.play("JumpPeak")
			else:
				animation.play("Jump")
		elif body.velocity.y > 0:
			animation.play("Fall")
