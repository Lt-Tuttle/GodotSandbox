class_name StateWallSlide
extends StateBase

@export var wall_slide_speed: float = 100.0
@export var wall_jump_velocity: Vector2 = Vector2(300, -400) # Up and Out

func enter() -> void:
	state_machine.animation_player.play(GameConstants.ANIM_WALL_SLIDE)

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
		
	# Check Ground
	if state_machine.body.is_on_floor():
		state_machine.change_state(StateGround)
		return
		
	var input_dir = state_machine.input_component.input_horizontal
	var facing_dir = state_machine.pivot.scale.x
	
	if input_dir != 0 and sign(input_dir) != sign(facing_dir):
		state_machine.change_state(StateAir)
		return

func physics_update(_delta: float) -> void:
	var current_velocity = state_machine.body.velocity
	
	state_machine.body.velocity.y = move_toward(current_velocity.y, wall_slide_speed, 800 * _delta) # 800 is friction accel
	
	var facing_dir = state_machine.pivot.scale.x
	state_machine.body.velocity.x = facing_dir * 10.0 # Tiny push into wall
	
	state_machine.body.move_and_slide()

func wall_jump() -> void:
	var facing_dir = state_machine.pivot.scale.x
	state_machine.body.velocity.x = - facing_dir * wall_jump_velocity.x
	state_machine.body.velocity.y = wall_jump_velocity.y
	state_machine.change_state(StateAir)

func check_wall_contact() -> bool:
	return state_machine.body.is_on_wall() or state_machine.wall_check.is_colliding()
