class_name StateJumping
extends StateBase

func enter() -> void:
	state_machine.animation_player.play(GameConstants.ANIM_JUMP)
	if state_machine.is_crouching:
		state_machine.is_crouching = false
		state_machine.body.collision_shape.scale = Vector2(1.0, state_machine.body.stand_player_collision_shape_scale)
		state_machine.body.collision_shape.position.y = state_machine.body.stand_player_collision_shape_offset

func exit() -> void:
	pass

func update(_delta: float) -> void:
	# Animation Logic
	var vy = state_machine.body.velocity.y
	var jump_threshold = state_machine.movement_component.jump_peak_threshold
	
	if vy < -jump_threshold:
		state_machine.animation_player.play(GameConstants.ANIM_JUMP)
	elif vy > jump_threshold:
		state_machine.animation_player.play(GameConstants.ANIM_FALL)
	else:
		state_machine.animation_player.play(GameConstants.ANIM_JUMP_PEAK)

	# Transitions
	if state_machine.body.is_on_floor():
		if state_machine.input_component.input_horizontal != 0:
			state_machine.change_state(StateMoving)
		else:
			state_machine.change_state(StateIdle)
		return
		
	# Attack in air
	if state_machine.input_component.consume_attack():
		state_machine.change_state(StateAttacking)
		return

	state_machine.update_facing_direction()

func physics_update(delta: float) -> void:
	# Air control
	var input_dir = state_machine.input_component.input_horizontal
	state_machine.movement_component.handle_velocity(input_dir, delta)
	state_machine.movement_component.apply_gravity(delta)
	state_machine.body.move_and_slide()
