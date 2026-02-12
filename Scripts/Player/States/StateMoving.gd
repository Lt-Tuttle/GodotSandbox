class_name StateMoving
extends Node

@export var state_machine: StateMachine

func enter() -> void:
	state_machine.animation_player.play("Run")

func exit() -> void:
	pass

func update(_delta: float) -> void:
	# Handle Crouch vs Run Animation
	if state_machine.input_component.crouch_pressed:
		if state_machine.animation_player.current_animation != "CrouchWalk":
			state_machine.animation_player.play("CrouchWalk")
		# Ensure collision is correct if we transitioned from Jump -> Move (crouched)
		state_machine.set_crouching_collision(true)
	else:
		state_machine.set_crouching_collision(false)
		if state_machine.animation_player.current_animation != "Run":
			state_machine.animation_player.play("Run")

	# Transitions
	if state_machine.input_component.input_horizontal == 0:
		state_machine.change_state("StateIdle")
		return

	if state_machine.input_component.jump_pressed:
		state_machine.change_state("StateJumping")
		return

	if state_machine.input_component.attack_pressed:
		state_machine.change_state("StateAttacking")
		return

	state_machine.update_facing_direction()

func physics_update(delta: float) -> void:
	state_machine.movement_component.HandleMovement(delta)
	state_machine.body.move_and_slide()
