class_name StateIdle
extends StateGround

func enter() -> void:
	state_machine.animation_player.play("Idle")

func update(delta: float) -> void:
	# 1. Base Class Logic (Handling inputs, crouch toggle, etc.)
	# We call super to handle transitions to Jump/Attack/Fall and Crouching
	super.update(delta)
	
	# 2. Specific Logic for Idle
	# If we are moving, transition to Moving
	if state_machine.input_component.input_horizontal != 0:
		state_machine.change_state("StateMoving")
		return
	
	# Check Crouch Animation
	if state_machine.is_crouching:
		if state_machine.animation_player.current_animation != "Crouch":
			state_machine.animation_player.play("Crouch")
	else:
		if state_machine.animation_player.current_animation != "Idle":
			state_machine.animation_player.play("Idle")

func physics_update(delta: float) -> void:
	super.physics_update(delta)
