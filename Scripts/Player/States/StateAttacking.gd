class_name StateAttacking
extends Node

@export var state_machine: StateMachine

func enter() -> void:
	state_machine.animation_player.play("Attack")

func exit() -> void:
	pass

func update(_delta: float) -> void:
	# Wait for animation to finish
	if not state_machine.animation_player.is_playing() or state_machine.animation_player.current_animation != "Attack":
		state_machine.change_state("StateIdle")
		return

func physics_update(delta: float) -> void:
	# FIX: Phantom Jump Bug
	# We DO NOT call perform_jump() or HandleMovement() which had checks.
	# We ONLY apply gravity and friction (horizontal 0).
	state_machine.movement_component.apply_gravity(delta)
	state_machine.movement_component.handle_velocity(0, delta) # Friction
	state_machine.body.move_and_slide()
