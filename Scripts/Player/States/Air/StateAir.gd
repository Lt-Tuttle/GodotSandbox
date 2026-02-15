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
	if input_component.consume_attack():
		state_machine.change_state(StateAttacking)
		return
	

	# Landing Logic
	if player.is_on_floor() and player.velocity.y >= 0:
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
	var input_dir = input_component.input_horizontal
	movement_component.handle_velocity(input_dir, delta)
	movement_component.apply_gravity(delta)
	
	if player.velocity.y > 0:
		movement_component.fall_time += delta
	else:
		movement_component.fall_time = 0.0
	
	player.move_and_slide()

func check_ledge_grab() -> bool:
	if not ledge_grab_state: return false
	if movement_component.wall_jump_lockout > 0: return false
	
	if player.wall_check.is_colliding() and not player.ledge_check.is_colliding():
		# Prevent grabbing if holding AWAY from wall
		var input = input_component.input_horizontal
		var facing = player.pivot.scale.x
		if input != 0 and sign(input) != sign(facing):
			return false
			
		state_machine.change_state(StateLedgeGrab)
		return true
			
	return false

func check_wall_slide() -> bool:
	if not wall_slide_state: return false
	
	# Only slide if falling
	if player.velocity.y > 0:
		# Check forward wall
		if player.is_on_wall():
			var input_dir = input_component.input_horizontal
			var facing_dir = player.pivot.scale.x
			
			# Must be holding TOWARDS the wall
			if input_dir != 0 and sign(input_dir) == sign(facing_dir):
				state_machine.change_state(StateWallSlide)
				return true
			
	return false
