class_name StateLanding
extends StateBase
var min_landing_time: float = 0.1
var time_elapsed: float = 0.0

func enter() -> void:
	time_elapsed = 0.0
	var fall_time = state_machine.movement_component.fall_time
	
	if fall_time >= 0.7:
		state_machine.animation_player.play(GameConstants.ANIM_LANDING_HEAVY)
	else:
		state_machine.animation_player.play(GameConstants.ANIM_LANDING)

func exit() -> void:
	state_machine.movement_component.fall_time = 0.0

func update(delta: float) -> void:
	time_elapsed += delta
	var current_anim = state_machine.animation_player.current_animation
	var is_landing_anim = current_anim == GameConstants.ANIM_LANDING or current_anim == GameConstants.ANIM_LANDING_HEAVY
	
	if not state_machine.animation_player.is_playing() or not is_landing_anim:
		if state_machine.input_component.input_horizontal != 0:
			state_machine.change_state(StateMoving)
		else:
			state_machine.change_state(StateIdle)
		return

	if state_machine.animation_player.current_animation != GameConstants.ANIM_LANDING_HEAVY:
		if state_machine.input_component.consume_jump():
			var jump_power = 1.0
			if time_elapsed < min_landing_time:
				jump_power = 0.75 # Weak jump if bunny hopping
				
			state_machine.movement_component.perform_jump(jump_power)
			state_machine.change_state(StateJumping)
			return
		
		if state_machine.input_component.consume_roll():
			state_machine.change_state(StateRoll)
			return

		if state_machine.input_component.consume_attack():
			state_machine.change_state(StateAttacking)
			return

func physics_update(delta: float) -> void:
	state_machine.movement_component.handle_velocity(0, delta)
	state_machine.movement_component.apply_gravity(delta)
	state_machine.body.move_and_slide()
