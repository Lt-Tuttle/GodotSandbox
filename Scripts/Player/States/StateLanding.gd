class_name StateLanding
extends StateBase

func enter() -> void:
	if state_machine.body.velocity.y <= state_machine.movement_component.max_fall_speed * 0.9:
		state_machine.animation_player.play(GameConstants.ANIM_LANDING_HEAVY)
	else:
		state_machine.animation_player.play(GameConstants.ANIM_LANDING)

func exit() -> void:
	pass

func update(_delta: float) -> void:
	# If animation finished, transition to appropriate state
	if not state_machine.animation_player.is_playing() or state_machine.animation_player.current_animation != GameConstants.ANIM_LANDING:
		if state_machine.input_component.input_horizontal != 0:
			state_machine.change_state(StateMoving)
		else:
			state_machine.change_state(StateIdle)
		return
	
	# Allow attacking or rolling to cancel landing recovery?
	if state_machine.input_component.consume_jump():
		# Bunny hop support
		state_machine.movement_component.perform_jump()
		state_machine.change_state(StateJumping)
		return
		
	if state_machine.input_component.consume_roll():
		state_machine.change_state(StateRoll)
		return

	if state_machine.input_component.consume_attack():
		state_machine.change_state(StateAttacking)
		return

func physics_update(delta: float) -> void:
	# Apply friction/stop while landing
	state_machine.movement_component.handle_velocity(0, delta)
	state_machine.movement_component.apply_gravity(delta)
	state_machine.body.move_and_slide()
