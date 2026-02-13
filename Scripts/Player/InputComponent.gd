class_name InputComponent
extends Node

@export var buffer_window: float = 0.4

var input_horizontal: float = 0.0
var jump_timestamp: int = 0
var crouch_timestamp: int = 0
var roll_timestamp: int = 0
var attack_timestamp: int = 0
var move_vector: Vector2 = Vector2.ZERO
var right_pressed: bool = false
var left_pressed: bool = false
var jump_held: bool = false

func CheckInputs():
	input_horizontal = Input.get_axis("MoveLeft", "MoveRight")
	
	if Input.is_action_just_pressed("Jump"):
		jump_timestamp = Time.get_ticks_msec()
		
	if Input.is_action_just_pressed("Crouch"):
		crouch_timestamp = Time.get_ticks_msec()
		
	if Input.is_action_just_pressed("Roll"):
		roll_timestamp = Time.get_ticks_msec()

	if Input.is_action_just_pressed("Attack"):
		attack_timestamp = Time.get_ticks_msec()
		
	right_pressed = Input.is_action_pressed("MoveRight")
	left_pressed = Input.is_action_pressed("MoveLeft")
	jump_held = Input.is_action_pressed("Jump")
	
	move_vector = Vector2(input_horizontal, 0)

func consume_jump() -> bool:
	var is_buffered = (Time.get_ticks_msec() - jump_timestamp) <= buffer_window * 1000
	if is_buffered:
		jump_timestamp = 0
	return is_buffered

func consume_attack() -> bool:
	var is_buffered = (Time.get_ticks_msec() - attack_timestamp) <= buffer_window * 1000
	if is_buffered:
		attack_timestamp = 0
	return is_buffered
	
func consume_roll() -> bool:
	var is_buffered = (Time.get_ticks_msec() - roll_timestamp) <= buffer_window * 1000
	if is_buffered:
		roll_timestamp = 0
	return is_buffered

func consume_crouch() -> bool:
	var is_buffered = (Time.get_ticks_msec() - crouch_timestamp) <= buffer_window * 1000
	if is_buffered:
		crouch_timestamp = 0
	return is_buffered
