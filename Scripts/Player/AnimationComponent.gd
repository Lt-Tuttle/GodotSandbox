class_name AnimationComponent
extends Node

func HandleAnimation(tree: AnimationTree, input: InputComponent, sprite: Sprite2D, body: CharacterBody2D):
	var dir = input.input_horizontal
	
	# Handle flipping (Visual only, doesn't affect logic usually)
	if dir != 0:
		if input.input_horizontal > 0 && body.velocity.x > 0:
			sprite.flip_h = false
		elif input.input_horizontal < 0 && body.velocity.x < 0:
			sprite.flip_h = true
	
	# The AnimationTree handles all logic via "Advance Expressions" checking velocity and input.
	# We no longer need to manually "Travel" in code.
	# The setup instructions for the Tree will be provided in the walkthrough.
	pass
