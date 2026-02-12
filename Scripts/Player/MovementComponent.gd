class_name MovementComponent
extends Node

@onready var body: CharacterBody2D = get_parent()
@onready var input_component: Node = body.get_node("InputComponent")

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
@export var coyote_time: float = 0.1
@export var jump_peak_gravity_mult: float = 0.5 # Lowers gravity at jump apex

var coyote_timer: float = 0.0
var is_crouching: bool = false

# Calculated once when the node is ready
@onready var jump_peak_threshold: float = abs(jump_velocity * 0.1)

func HandleMovement(delta: float) -> void:
	if not body or not input_component:
		return

	# 1. Update Coyote Timer
	if body.is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

	# 2. Handle Jumping
	# We check if jump is pressed AND we have coyote time remaining.
	if input_component.jump_pressed and coyote_timer > 0.0:
		body.velocity.y = jump_velocity
		coyote_timer = 0.0 # Consume the timer so we can't double jump
        
	# 3. Handle Gravity
	if not body.is_on_floor():
		var current_gravity = gravity
        
		# Apply floaty apex: if we are moving slowly vertically (at the peak of the jump)
		if abs(body.velocity.y) < jump_peak_threshold:
			current_gravity *= jump_peak_gravity_mult
            
		body.velocity.y += current_gravity * delta
		body.velocity.y = min(body.velocity.y, max_fall_speed)

	# 4. Handle Crouching
	# It is safer to toggle a boolean state rather than permanently mutating the `speed` variable.
	if input_component.crouch_pressed and not is_crouching:
		is_crouching = true
	elif input_component.crouch_released and is_crouching:
		is_crouching = false

	# 5. Handle Horizontal Movement
	var direction: float = input_component.input_horizontal
	var target_speed: float = base_speed * (crouch_speed_multiplier if is_crouching else 1.0)
    
	var acc: float = acceleration if body.is_on_floor() else air_acceleration
	var fric: float = friction if body.is_on_floor() else air_friction
    
	if direction != 0.0:
		body.velocity.x = move_toward(body.velocity.x, direction * target_speed, acc * delta)
	else:
		# Decelerate when no input is provided
		body.velocity.x = move_toward(body.velocity.x, 0.0, fric * delta)
