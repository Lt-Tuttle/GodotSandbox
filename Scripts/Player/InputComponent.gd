class_name InputComponent
extends Node

var raw_input: Vector2 = Vector2.ZERO
var move_vector: Vector2 = Vector2.ZERO
var last_move_direction: Vector2 = Vector2.DOWN
var _was_horizontal_priority: bool = true

func CheckInputs():
	raw_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		_was_horizontal_priority = true
	elif Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("move_down"):
		_was_horizontal_priority = false
	
	move_vector = Vector2.ZERO
	
	if raw_input != Vector2.ZERO:
		if _was_horizontal_priority and raw_input.x != 0:
			move_vector.x = sign(raw_input.x)
		elif not _was_horizontal_priority and raw_input.y != 0:
			move_vector.y = sign(raw_input.y)
		else:
			if raw_input.x != 0:
				move_vector.x = sign(raw_input.x)
				_was_horizontal_priority = true
			else:
				move_vector.y = sign(raw_input.y)
				_was_horizontal_priority = false
	
	if move_vector != Vector2.ZERO:
		last_move_direction = move_vector
