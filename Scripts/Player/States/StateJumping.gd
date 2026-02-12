class_name StateJumping
extends Node

@export var state_machine: StateMachine

func enter() -> void:
	state_machine.animation_player.play("Jump")
	# We don't reset collision here, handled by animation usually or not needed if we are in air.
	# But if we were crouched, we might want to ensure we aren't? 
	# The requirement says StateMachine has var is_crouching.
	# If we jump, we probably want to uncrouch?
	if state_machine.is_crouching:
		state_machine.is_crouching = false

func exit() -> void:
	pass

func update(_delta: float) -> void:
	# Animation Logic
	var vy = state_machine.body.velocity.y
	var jump_threshold = state_machine.movement_component.jump_peak_threshold
	
	if vy < -jump_threshold:
		state_machine.animation_player.play("Jump")
	elif vy > jump_threshold:
		state_machine.animation_player.play("Fall")
	else:
		state_machine.animation_player.play("JumpPeak")

	# Transitions
	if state_machine.body.is_on_floor():
		if state_machine.input_component.input_horizontal != 0:
			state_machine.change_state("StateMoving")
		else:
			state_machine.change_state("StateIdle")
		return
		
	# Attack in air? (Optional, assuming allowed for now)
	if state_machine.input_component.consume_attack():
		state_machine.change_state("StateAttacking")
		return

	state_machine.update_facing_direction()

func physics_update(delta: float) -> void:
	# Air control
	var input_dir = state_machine.input_component.input_horizontal
	state_machine.movement_component.handle_velocity(input_dir, delta)
	state_machine.movement_component.apply_gravity(delta)
	state_machine.body.move_and_slide()
