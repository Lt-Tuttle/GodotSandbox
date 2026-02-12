extends PlayerState

func enter(msg := {}) -> void:
	if msg.has("do_jump"):
		player.velocity.y = movement_component.jump_velocity
		if playback: playback.travel("Jump")
	else:
		if playback: playback.travel("Fall")

func physics_update(delta: float) -> void:
	movement_component.HandleMovement(input_component, delta)
	
	# Animation logic for Jump Peak
	if playback and abs(player.velocity.y) < 50:
		playback.travel("JumpPeak")
	
	if player.is_on_floor():
		if input_component.input_horizontal == 0:
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Move")
