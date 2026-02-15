class_name StateIdle
extends StateGround

func enter() -> void:
	player.animation_player.play(GameConstants.ANIM_IDLE)

func update(delta: float) -> void:
	# 1. Base Class Logic (Handling inputs, crouch toggle, etc.)
	# We call super to handle transitions to Jump/Attack/Fall and Crouching
	super.update(delta)
	
	# If state changed in super (e.g. to Attack), stop processing
	if state_machine.current_state != self:
		return
	
	# 2. Specific Logic for Idle
	# If we are moving, transition to Moving
	if input_component.input_horizontal != 0:
		state_machine.change_state(StateMoving)
		return
	
	# Check Crouch Animation
	if state_machine.is_crouching:
		if player.animation_player.current_animation != GameConstants.ANIM_CROUCH:
			player.animation_player.play(GameConstants.ANIM_CROUCH_TRANSITION)
			player.animation_player.queue(GameConstants.ANIM_CROUCH)
	else:
		if player.animation_player.current_animation != GameConstants.ANIM_IDLE:
			player.animation_player.play(GameConstants.ANIM_CROUCH_TRANSITION)
			player.animation_player.queue(GameConstants.ANIM_IDLE)

func physics_update(delta: float) -> void:
	super.physics_update(delta)
