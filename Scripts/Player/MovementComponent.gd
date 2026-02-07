class_name MovementComponent
extends Node

@export var speed: float = 100

func HandleMovement(body: CharacterBody2D, input: InputComponent, _delta: float):
	# No logic needed here. Just read the pre-calculated vector.
	body.velocity = input.move_vector * speed
