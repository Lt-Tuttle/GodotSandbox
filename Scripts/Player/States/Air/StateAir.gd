class_name StateAir
extends StateBase

@export var ledge_grab_state: StateBase
@export var wall_slide_state: StateBase

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
	# Ledge/Wall Logic
	if check_ledge_grab():
		return
	if check_wall_slide():
		return

	# Air control
	var input_dir = state_machine.input_component.input_horizontal
	state_machine.movement_component.handle_velocity(input_dir, delta)
	state_machine.movement_component.apply_gravity(delta)
	
	if state_machine.body.velocity.y > 0:
		state_machine.movement_component.fall_time += delta
	else:
		state_machine.movement_component.fall_time = 0.0
	
	state_machine.body.move_and_slide()

func check_ledge_grab() -> bool:
	if not ledge_grab_state: return false
	
	# Forward Check
	if state_machine.wall_check.is_colliding() and not state_machine.ledge_check.is_colliding():
		state_machine.change_state(StateLedgeGrab)
		return true

	# Backward Check (Walk-off logic)
	# Only if we are falling and just started falling (to avoid snapping mid-air randomly?)
	# Or if velocity.y is positive.
	if state_machine.body.velocity.y > 0:
		if state_machine.back_wall_check.is_colliding() and not state_machine.back_ledge_check.is_colliding():
			# Flip character to face the wall
			state_machine.pivot.scale.x *= -1
			state_machine.change_state(StateLedgeGrab)
			return true
			
	return false

func check_wall_slide() -> bool:
	if not wall_slide_state: return false
	
	# Only slide if falling
	if state_machine.body.velocity.y > 0:
		# Check forward wall
		if state_machine.wall_check.is_colliding():
			var input_dir = state_machine.input_component.input_horizontal
			var facing_dir = state_machine.pivot.scale.x
			
			# Must be holding TOWARDS the wall
			if input_dir != 0 and sign(input_dir) == sign(facing_dir):
				state_machine.change_state(StateWallSlide)
				return true
			
	return false
