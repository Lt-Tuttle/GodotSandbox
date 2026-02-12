class_name InputComponent
extends Node

var input_horizontal: float = 0.0
var jump_pressed: bool = false
var crouch_pressed: bool = false
var crouch_released: bool = false
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
		crouch_pressed = true # Start crouching
	if Input.is_action_just_released("Crouch"):
		crouch_released = true
		crouch_pressed = false # Stop crouching
		
	if Input.is_action_pressed("Crouch"): # Continuous check logic if needed, but the latching above helps transitions
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

func consume_crouch_trigger() -> bool: # For just_pressed logic if we need it
	# Actually crouch is usually a state, so `crouch_pressed` boolean is fine to persist.
	# But `crouch_released` might need consumption?
	# Let's just keep crouch as a state variable for now, but `released` might need latching.
	return false
