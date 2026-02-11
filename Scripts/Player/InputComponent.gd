class_name InputComponent
extends Node

var input_horizontal: float = 0.0
var jump_pressed: bool = false
var crouch_pressed: bool = false
var roll_pressed: bool = false
var attack_pressed: bool = false
var move_vector: Vector2 = Vector2.ZERO

func CheckInputs():
	input_horizontal = Input.get_axis("MoveLeft", "MoveRight")
	jump_pressed = Input.is_action_just_pressed("Jump")
	crouch_pressed = Input.is_action_pressed("Crouch")
	roll_pressed = Input.is_action_just_pressed("Roll")
	attack_pressed = Input.is_action_just_pressed("Attack")
	
	move_vector = Vector2(input_horizontal, 0)
