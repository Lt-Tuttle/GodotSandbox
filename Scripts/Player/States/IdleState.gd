# IdleState.gd
extends PlayerState

func enter(_msg := {}) -> void:
	# Check if the player has an AnimationComponent and use it, or drive the tree directly.
	# For now, let's assume we want to drive the tree directly or via the component.
	# The original code used AnimationComponent.HandleAnimation.
	# We might want to just set the velocity to zero.
	player.velocity = Vector2.ZERO
	if playback:
		playback.travel("Idle")

func physics_update(_delta: float) -> void:
	# Stop the player if they rely on inertia, or just ensure 0 velocity.
	# Using separate components for gravity/movement might require calling them differently.
	# However, typically Idle simply checks for input to transition to Move or Air.
	input_component.CheckInputs()
	
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return

	if input_component.jump_pressed:
		state_machine.transition_to("Air", {do_jump = true})
	elif input_component.input_horizontal != 0:
		state_machine.transition_to("Move")
