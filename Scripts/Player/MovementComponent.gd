class_name MovementComponent
extends Node

@export var speed: float = 160
@export var acceleration: float = 1600
@export var friction: float = 1600
@export var jump_velocity: float = -320.0

@export var air_acceleration: float = 800
@export var air_friction: float = 1600

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func HandleMovement(input: InputComponent, delta: float):
	var body = get_parent() as CharacterBody2D
	if not body:
		return

	if not body.is_on_floor():
		body.velocity.y += gravity * delta

	if input.jump_pressed and body.is_on_floor():
		body.velocity.y = jump_velocity

	var direction = input.input_horizontal
	var acc = acceleration if body.is_on_floor() else air_acceleration
	var fric = friction if body.is_on_floor() else air_friction
	
	if direction:
		body.velocity.x = move_toward(body.velocity.x, direction * speed, acc * delta)
	else:
		body.velocity.x = move_toward(body.velocity.x, 0, fric * delta)
