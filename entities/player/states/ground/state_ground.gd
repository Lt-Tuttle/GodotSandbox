class_name StateGround
extends StateBase

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	# Attack
	if input_component.consume_attack():
		state_machine.change_state(StateAttacking)
		return

	# Roll
	if input_component.consume_roll():
		state_machine.change_state(StateRoll)
		return

	# Jump
	if input_component.consume_jump():
		movement_component.perform_jump()
		state_machine.change_state(StateJumping)
		return

	# Crouch
	if input_component.consume_crouch():
		if not state_machine.is_crouching:
			state_machine.is_crouching = true
			movement_component.set_crouch_state(true)
			return
			
		else: # Already crouching
			state_machine.is_crouching = false
			movement_component.set_crouch_state(false)
			return
	
	# Fall
	if not player.is_on_floor():
		state_machine.change_state(StateFalling)
		return

	# Update Direction
	state_machine.update_facing_direction()

func physics_update(delta: float) -> void:
	# Shared movement logic
	var input_dir = input_component.input_horizontal
	var speed_mult = movement_component.crouch_speed_multiplier if state_machine.is_crouching else 1.0
	
	movement_component.handle_velocity(input_dir, delta, speed_mult)
	movement_component.apply_gravity(delta)
	player.move_and_slide()
