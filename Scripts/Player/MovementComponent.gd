class_name MovementComponent
extends Node

@export var speed: float = 100
@export var acceleration: float = 800
@export var friction: float = 2000
@export var jump_velocity: float = -300.0

@export var air_acceleration: float = 400
@export var air_friction: float = 500

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func HandleMovement(input: InputComponent, delta: float):
	var body = get_parent() as CharacterBody2D
	if not body:
		return

	# Add the gravity.
	if not body.is_on_floor():
		body.velocity.y += gravity * delta

	# Handle Jump.
	if input.jump_pressed and body.is_on_floor():
		body.velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	var direction = input.input_horizontal
	
	# Choose acceleration/friction based on state
	var acc = acceleration if body.is_on_floor() else air_acceleration
	var fric = friction if body.is_on_floor() else air_friction
	
	if direction:
		body.velocity.x = move_toward(body.velocity.x, direction * speed, acc * delta)
	else:
		body.velocity.x = move_toward(body.velocity.x, 0, fric * delta)
