class_name StateLedgeGrab
extends StateBase

func enter() -> void:
	state_machine.body.velocity = Vector2.ZERO
	
	snap_to_ledge()
	
	state_machine.animation_player.play(GameConstants.ANIM_LEDGE_GRAB)

func exit() -> void:
	pass

func update(_delta: float) -> void:
	if state_machine.input_component.consume_crouch() or state_machine.input_component.crouch_held:
		state_machine.change_state(StateWallSlide)
		return

	if state_machine.input_component.consume_jump():
		state_machine.change_state(StateLedgeClimb)
		return

func physics_update(_delta: float) -> void:
	state_machine.body.velocity = Vector2.ZERO


func snap_to_ledge() -> void:
	var wall_check = state_machine.wall_check
	var ledge_top_check = state_machine.ledge_top_check

	wall_check.force_raycast_update()
	ledge_top_check.force_raycast_update()

	if wall_check.is_colliding() and ledge_top_check.is_colliding():
		var wall_point = wall_check.get_collision_point()
		var ledge_point = ledge_top_check.get_collision_point()
		
		var corner_x = wall_point.x
		var corner_y = ledge_point.y
		
		var direction = state_machine.pivot.scale.x
		
		state_machine.body.global_position.x = corner_x - (state_machine.grab_position.position.x * direction)
		state_machine.body.global_position.y = corner_y - state_machine.grab_position.position.y