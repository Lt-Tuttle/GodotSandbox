class_name StateIdle
extends Node

@export var state_machine: StateMachine

func enter() -> void:
	state_machine.animation_player.play("Idle")

func exit() -> void:
	pass

func update(_delta: float) -> void:
	# Handle Crouch
	if state_machine.input_component.crouch_pressed:
		if state_machine.animation_player.current_animation != "Crouch":
			state_machine.animation_player.play("Crouch")
		state_machine.set_crouching_collision(true)
	elif state_machine.input_component.crouch_released:
		state_machine.set_crouching_collision(false)
		state_machine.animation_player.play("Idle")
	
	# Transitions
	if state_machine.input_component.input_horizontal != 0:
		state_machine.change_state("StateMoving")
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
