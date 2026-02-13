class_name StateJumping
extends StateAir

func enter() -> void:
	state_machine.animation_player.play(GameConstants.ANIM_JUMP)
	if state_machine.is_crouching:
		state_machine.is_crouching = false
		state_machine.movement_component.set_crouch_state(false)

func exit() -> void:
	pass

func update(delta: float) -> void:
	# Animation Logic
	var vy = state_machine.body.velocity.y
	var jump_threshold = state_machine.movement_component.jump_peak_threshold
	
	if vy < -jump_threshold:
		state_machine.animation_player.play(GameConstants.ANIM_JUMP)
	elif vy > jump_threshold:
		state_machine.change_state(StateFalling)
		return
	else:
		state_machine.animation_player.play(GameConstants.ANIM_JUMP_PEAK)

	# Shared Air Logic (Landing, Attacks, Direction)
	super.update(delta)

func physics_update(delta: float) -> void:
	super.physics_update(delta)
