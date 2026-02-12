class_name StateGround
extends Node

@export var state_machine: StateMachine

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	# 1. Handle Crouching
	# Toggle state based on input.
	if state_machine.input_component.crouch_pressed:
		if not state_machine.is_crouching:
			state_machine.is_crouching = true
			# We don't handle collision shape here anymore (AnimationPlayer should do it)
			# But if we did, it would be here.
	elif state_machine.input_component.crouch_released: # Optional: if crouch is hold-to-crouch
		# Depending on requirements, crouch might be toggle or hold.
		# Original code suggested hold logic:
		# "elif state_machine.input_component.crouch_released: state_machine.set_crouching_collision(false)"
		# So we will implement hold-to-crouch logic here.
		if state_machine.is_crouching:
			state_machine.is_crouching = false

	# 2. Transitions
	
	# Jump
	if state_machine.input_component.consume_jump():
		state_machine.movement_component.perform_jump()
		state_machine.change_state("StateJumping")
		return

	# Attack
	if state_machine.input_component.consume_attack():
		state_machine.change_state("StateAttacking")
		return

	# Fall (if we walked off a ledge)
	if not state_machine.body.is_on_floor():
		state_machine.change_state("StateJumping") # Or StateFall if it exists, reusing Jumping for now as per original code context
		return

	# Update Direction
	state_machine.update_facing_direction()

func physics_update(delta: float) -> void:
	# Shared movement logic
	var input_dir = state_machine.input_component.input_horizontal
	var speed_mult = state_machine.movement_component.crouch_speed_multiplier if state_machine.is_crouching else 1.0
	
	state_machine.movement_component.handle_velocity(input_dir, delta, speed_mult)
	state_machine.movement_component.apply_gravity(delta)
	state_machine.body.move_and_slide()
