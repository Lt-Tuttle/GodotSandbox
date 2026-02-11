class_name InputComponent
extends Node

var input_horizontal: float = 0.0
var jump_pressed: bool = false
var move_vector: Vector2 = Vector2.ZERO # Kept for compatibility but strictly horizontal

func CheckInputs():
	input_horizontal = Input.get_axis("move_left", "move_right")
	jump_pressed = Input.is_action_just_pressed("move_up")
	
	move_vector = Vector2(input_horizontal, 0)
