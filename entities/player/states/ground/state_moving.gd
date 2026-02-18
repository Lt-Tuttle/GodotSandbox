class_name StateMoving
extends StateGround

func enter() -> void:
	player.animation_player.play(GameConstants.ANIM_RUN)

func update(delta: float) -> void:
	# 1. Base Class Logic
	super.update(delta)

	# If state changed in super (e.g. to Attack), stop processing
	if state_machine.current_state != self:
		return
	
	# 2. Specific Logic for Moving
	if input_component.input_horizontal == 0:
		state_machine.change_state(StateIdle)
		return

	# Check Crouch Animation
	if state_machine.is_crouching:
		if player.animation_player.current_animation != GameConstants.ANIM_CROUCH_WALK:
			player.animation_player.play(GameConstants.ANIM_CROUCH_WALK)
	else:
		if sign(input_component.input_horizontal) != sign(player.velocity.x) and player.velocity.x != 0.0:
			if player.animation_player.current_animation != GameConstants.ANIM_TURN_AROUND:
				player.animation_player.play(GameConstants.ANIM_TURN_AROUND)
				player.animation_player.queue(GameConstants.ANIM_RUN)
		else:
			if player.animation_player.current_animation != GameConstants.ANIM_RUN:
				player.animation_player.play(GameConstants.ANIM_RUN)

func physics_update(delta: float) -> void:
	super.physics_update(delta)
