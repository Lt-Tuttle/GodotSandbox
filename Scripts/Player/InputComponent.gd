class_name InputComponent
extends Node

var input_horizontal: float = 0.0
var jump_pressed: bool = false
var crouch_pressed: bool = false
var roll_pressed: bool = false
var attack_pressed: bool = false
var move_vector: Vector2 = Vector2.ZERO
var right_pressed: bool = false
var left_pressed: bool = false

func CheckInputs():
	input_horizontal = Input.get_axis("MoveLeft", "MoveRight")
	
	if Input.is_action_just_pressed("Jump"):
		jump_pressed = true
		
	if Input.is_action_just_pressed("Crouch"):
		crouch_pressed = true
		
	if Input.is_action_just_pressed("Roll"):
		roll_pressed = true

	if Input.is_action_just_pressed("Attack"):
		attack_pressed = true
		
	right_pressed = Input.is_action_pressed("MoveRight")
	left_pressed = Input.is_action_pressed("MoveLeft")
	
	move_vector = Vector2(input_horizontal, 0)

func consume_jump() -> bool:
	var pressed = jump_pressed
	jump_pressed = false
	return pressed

func consume_attack() -> bool:
	var pressed = attack_pressed
	attack_pressed = false
	return pressed
	
func consume_roll() -> bool:
	var pressed = roll_pressed
	roll_pressed = false
	return pressed

func consume_crouch() -> bool:
	var pressed = crouch_pressed
	crouch_pressed = false
	return pressed
