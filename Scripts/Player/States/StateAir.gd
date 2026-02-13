class_name StateAir
extends StateBase

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	# Attack in air
	if state_machine.input_component.consume_attack():
		state_machine.change_state(StateAttacking)
		return
	

	# Landing Logic
	if state_machine.body.is_on_floor() and state_machine.body.velocity.y >= 0:
		state_machine.change_state(StateLanding)
		return

	# Update Direction
	state_machine.update_facing_direction()

func physics_update(delta: float) -> void:
	# Air control
	var input_dir = state_machine.input_component.input_horizontal
	state_machine.movement_component.handle_velocity(input_dir, delta)
	state_machine.movement_component.apply_gravity(delta)
	state_machine.body.move_and_slide()
