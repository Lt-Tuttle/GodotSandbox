# MoveState.gd
extends PlayerState

func enter(_msg := {}) -> void:
	if playback:
		playback.travel("Run") # Assuming "Run" is the state name for moving

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return

	if Input.is_action_just_pressed("Jump"):
		state_machine.transition_to("Air", {do_jump = true})
		return
		
	# We can reuse the MovementComponent logic or duplicate it here.
	# For FSM purity, it's often better to have the logic here or call a specific helper.
	# Detailed implementation plan said "integrating MovementComponent logic".
	# The MovementComponent has HandleMovement. We can try to use it if we can access it,
	# but PlayerState needs a reference. 
	# Let's assume for now we act as the glue.
	
	# Get input from InputComponent
	input_component.CheckInputs()
	
	if input_component.input_horizontal == 0:
		state_machine.transition_to("Idle")
		return
		
	# We need to manually drive movement here since we logic is now split.
	# Or we modify MovementComponent to just return velocity and we apply it.
	# Existing MovementComponent applies move_toward to velocity.
	movement_component.HandleMovement(input_component, delta)
	player.move_and_slide()
	
	if playback:
		# Detect Turnaround
		# input_horizontal is updated in CheckInputs()
		var dir = input_component.input_horizontal
		if dir != 0 and sign(dir) != sign(player.velocity.x) and abs(player.velocity.x) > 100:
			playback.travel("Turnaround")
		else:
			# Ensure we are in Run if not turning around (and not transitioning out)
			# But we rely on State machine to be in Run. 
			# However, if we played Turnaround, we might want to go back to Run automatically?
			# Usually Turnaround passes into Run. 
			# For now, let's just trigger Turnaround.
			pass

	
	# Handle Turnaround check (visuals will be handled by AnimationTree reading velocity)
