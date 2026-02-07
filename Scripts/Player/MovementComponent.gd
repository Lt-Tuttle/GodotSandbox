class_name MovementComponent
extends Node

@export var speed: float = 100
@export var acceleration: float = 800
@export var friction: float = 2000

func HandleMovement(body: CharacterBody2D, input: InputComponent, delta: float):
	if input.move_vector != Vector2.ZERO:
		body.velocity = body.velocity.move_toward(input.move_vector * speed, acceleration * delta)
	else:
		body.velocity = body.velocity.move_toward(Vector2.ZERO, friction * delta)
