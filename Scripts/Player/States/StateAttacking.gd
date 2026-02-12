class_name StateAttacking
extends StateBase

func enter() -> void:
	if state_machine.is_crouching:
		state_machine.animation_player.play(GameConstants.ANIM_CROUCH_ATTACK)
	else:
		state_machine.animation_player.play(GameConstants.ANIM_ATTACK)

func exit() -> void:
	pass

func update(_delta: float) -> void:
	# Wait for animation to finish
	if not state_machine.animation_player.is_playing():
		state_machine.change_state(StateIdle)
		return

func physics_update(delta: float) -> void:
	state_machine.movement_component.apply_gravity(delta)
	state_machine.movement_component.handle_velocity(0, delta) # Friction
	state_machine.body.move_and_slide()
