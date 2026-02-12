extends PlayerState

func enter(_msg := {}) -> void:
	if playback:
		playback.travel("Run")

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return

	if Input.is_action_just_pressed("Jump"):
		state_machine.transition_to("Air", {do_jump = true})
		return
		
	if input_component.input_horizontal == 0:
		state_machine.transition_to("Idle")
		return
		
	movement_component.HandleMovement(input_component, delta)
	
	if playback:
		var dir = input_component.input_horizontal
		if dir != 0 and sign(dir) != sign(player.velocity.x) and abs(player.velocity.x) > 100:
			playback.travel("TurnAround")
		else:
			pass
