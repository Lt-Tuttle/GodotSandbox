class_name MovementComponent
extends Node

@onready var body: CharacterBody2D = get_parent()
@onready var animation_player: AnimationPlayer = body.get_node("AnimationPlayer")
@onready var input_component: InputComponent = body.get_node("InputComponent")
@onready var movement_component: MovementComponent = body.get_node("MovementComponent")
@onready var sprite_2d: Sprite2D = body.get_node("Sprite2D")

@export var speed: float = 160
@export var acceleration: float = 800
@export var friction: float = 600
@export var jump_velocity: float = -400
@export var air_acceleration: float = 400
@export var air_friction: float = 200

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_crouching = false

func HandleMovement(input: InputComponent, delta: float):
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

	if input_component.crouch_pressed and not is_crouching:
		speed = speed / 2
		is_crouching = true
	elif input_component.crouch_released and is_crouching:
		speed = speed * 2
		is_crouching = false