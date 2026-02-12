class_name StateGround
extends Node

@export var state_machine: StateMachine

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	# Crouch
	if state_machine.input_component.crouch_pressed:
		if not state_machine.is_crouching:
			state_machine.is_crouching = true
			state_machine.body.collision_shape.scale = Vector2(1.0, state_machine.body.crouch_collision_shape_scale)
			state_machine.body.collision_shape.position.y = state_machine.body.crouch_collision_shape_offset
			state_machine.input_component.consume_crouch()
			return
			
		if state_machine.is_crouching:
			state_machine.is_crouching = false
			state_machine.body.collision_shape.scale = Vector2(1.0, state_machine.body.stand_collision_shape_scale)
			state_machine.body.collision_shape.position.y = state_machine.body.stand_collision_shape_offset
			state_machine.input_component.consume_crouch()
			return
	
	# Jump
	if state_machine.input_component.consume_jump():
		state_machine.movement_component.perform_jump()
		state_machine.change_state("StateJumping")
		return

	# Attack
	if state_machine.input_component.consume_attack():
		state_machine.change_state("StateAttacking")
		return

	# Fall
	if not state_machine.body.is_on_floor():
		state_machine.change_state("StateJumping")
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
