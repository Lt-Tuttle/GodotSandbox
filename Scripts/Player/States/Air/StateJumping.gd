class_name StateJumping
extends StateAir

func enter() -> void:
	player.animation_player.play(GameConstants.ANIM_JUMP)
	if state_machine.is_crouching:
		state_machine.is_crouching = false
		movement_component.set_crouch_state(false)

func exit() -> void:
	pass

func update(delta: float) -> void:
	# Animation Logic
	var vy = player.velocity.y
	var jump_threshold = movement_component.get_jump_peak_threshold()
	
	if vy < -jump_threshold:
		player.animation_player.play(GameConstants.ANIM_JUMP)
	elif vy > jump_threshold:
		state_machine.change_state(StateFalling)
		return
	else:
		player.animation_player.play(GameConstants.ANIM_JUMP_PEAK)

	# Shared Air Logic (Landing, Attacks, Direction)
	super.update(delta)

func physics_update(delta: float) -> void:
	# Variable Jump Height
	# Must apply BEFORE gravity (in super.physics_update) for responsive feel
	if not input_component.jump_held:
		var jump_cut_velocity = movement_component.jump_velocity * 0.5
		if player.velocity.y < jump_cut_velocity:
			player.velocity.y = jump_cut_velocity
			
	super.physics_update(delta)
