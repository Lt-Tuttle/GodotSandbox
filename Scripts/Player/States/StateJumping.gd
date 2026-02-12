class_name StateJumping
extends Node

@export var state_machine: StateMachine

func enter() -> void:
	state_machine.animation_player.play("Jump")
	state_machine.set_crouching_collision(false) # Reset crouch just in case

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
	if state_machine.input_component.attack_pressed:
		state_machine.change_state("StateAttacking")
		return

	state_machine.update_facing_direction()

func physics_update(delta: float) -> void:
	state_machine.movement_component.HandleMovement(delta)
	state_machine.body.move_and_slide()
