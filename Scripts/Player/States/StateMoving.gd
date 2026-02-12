class_name StateMoving
extends StateGround
	
func enter() -> void:
	state_machine.animation_player.play("Run")

func update(delta: float) -> void:
	# 1. Base Class Logic
	super.update(delta)
	
	# 2. Specific Logic for Moving
	if state_machine.input_component.input_horizontal == 0:
		state_machine.change_state("StateIdle")
		return

	# Check Crouch Animation
	if state_machine.is_crouching:
		if state_machine.animation_player.current_animation != "CrouchWalk":
			state_machine.animation_player.play("CrouchWalk")
	else:
		if state_machine.animation_player.current_animation != "Run":
			state_machine.animation_player.play("Run")

func physics_update(delta: float) -> void:
	super.physics_update(delta)
