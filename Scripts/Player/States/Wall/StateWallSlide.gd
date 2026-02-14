class_name StateWallSlide
extends StateBase


func enter() -> void:
	state_machine.animation_player.play(GameConstants.ANIM_WALL_SLIDE)
	state_machine.pivot.scale.x *= -1

func exit() -> void:
	pass

func update(_delta: float) -> void:
	# Jump -> Wall Jump
	if state_machine.input_component.consume_jump():
		wall_jump()
		return
		
	# Check if we are still on wall
	if not check_wall_contact():
		state_machine.change_state(StateAir)
		return
		
	# Check input: must hold towards wall
	var input_dir = state_machine.input_component.input_horizontal
	var facing_dir = state_machine.pivot.scale.x
	
	# Since sprite flips away from wall, input must be opposite to facing dir
	if input_dir == 0 or sign(input_dir) == sign(facing_dir):
		state_machine.change_state(StateAir)
		return

	# Check Ground
	if state_machine.ground_check.is_colliding():
		state_machine.change_state(StateGround)
		return
		

func physics_update(_delta: float) -> void:
	var current_velocity = state_machine.body.velocity
	
	state_machine.body.velocity.y = move_toward(current_velocity.y, state_machine.movement_component.wall_slide_speed, 800 * _delta) # 800 is friction accel
	
	var facing_dir = state_machine.pivot.scale.x
	state_machine.body.velocity.x = - facing_dir * 10.0 # Tiny push into wall
	
	state_machine.body.move_and_slide()

func wall_jump() -> void:
	var facing_dir = state_machine.pivot.scale.x
	var jump_vel = state_machine.movement_component.wall_jump_velocity
	state_machine.body.velocity.x = facing_dir * jump_vel.x
	state_machine.body.velocity.y = jump_vel.y
	state_machine.change_state(StateJumping)

func check_wall_contact() -> bool:
	return state_machine.body.is_on_wall() or state_machine.wall_check.is_colliding()
