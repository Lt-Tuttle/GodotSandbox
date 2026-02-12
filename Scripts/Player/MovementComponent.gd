class_name MovementComponent
extends Node

@onready var body: CharacterBody2D = get_parent()
# InputComponent dependency removed

@export_category("Speed & Acceleration")
@export var base_speed: float = 160.0
@export var crouch_speed_multiplier: float = 0.5
@export var acceleration: float = 800.0
@export var friction: float = 600.0
@export var air_acceleration: float = 400.0
@export var air_friction: float = 200.0

@export_category("Jumping & Gravity")
@export var jump_velocity: float = -400.0
@export var gravity: float = 1000.0
@export var max_fall_speed: float = 400.0
@export var coyote_time: float = 0.2
@export var jump_peak_gravity_mult: float = 0.5 # Lowers gravity at jump apex

var coyote_timer: float = 0.0
# is_crouching removed (passed as argument now)

# Calculated once when the node is ready
@onready var jump_peak_threshold: float = abs(jump_velocity * 0.1)

func _physics_process(delta: float) -> void:
	# Update Coyote Timer independently of state
	if body.is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

func get_gravity() -> float:
	var current_gravity = gravity
	# Apply floaty apex
	if abs(body.velocity.y) < jump_peak_threshold:
		current_gravity *= jump_peak_gravity_mult
	return current_gravity

func apply_gravity(delta: float, gravity_multiplier: float = 1.0) -> void:
	if not body.is_on_floor():
		var g = get_gravity() * gravity_multiplier
		body.velocity.y += g * delta
		body.velocity.y = min(body.velocity.y, max_fall_speed)

func handle_velocity(input_dir: float, delta: float, speed_mult: float = 1.0) -> void:
	var target_speed: float = base_speed * speed_mult
	
	var acc: float = acceleration if body.is_on_floor() else air_acceleration
	var fric: float = friction if body.is_on_floor() else air_friction
	
	if input_dir != 0.0:
		body.velocity.x = move_toward(body.velocity.x, input_dir * target_speed, acc * delta)
	else:
		body.velocity.x = move_toward(body.velocity.x, 0.0, fric * delta)

func perform_jump() -> void:
	if body.is_on_floor() or coyote_timer > 0.0:
		body.velocity.y = jump_velocity
		coyote_timer = 0.0
