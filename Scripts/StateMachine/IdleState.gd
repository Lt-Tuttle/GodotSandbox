extends PlayerState

func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO
	if playback:
		playback.travel("Idle")


func physics_update(_delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return

	if input_component.jump_pressed:
		state_machine.transition_to("Air", {do_jump = true})
	elif input_component.input_horizontal != 0:
		state_machine.transition_to("Move")
