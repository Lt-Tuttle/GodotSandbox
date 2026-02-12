class_name StateMachine
extends Node

#Get all nodes
@onready var body: CharacterBody2D = get_parent()
@onready var animation_player: AnimationPlayer = body.get_node("AnimationPlayer")
@onready var sprite_2d: Sprite2D = body.get_node("Sprite2D")

@export var attack_hitbox: Area2D
@export var crouch_attack_hitbox: Area2D

@export var attack_hitbox_collision_shape: CollisionShape2D
@export var crouch_hitbox_collision_shape: CollisionShape2D

# Dependency Injection
@export var input_component: InputComponent
@export var movement_component: MovementComponent

# State Variables
var is_crouching: bool = false

#Get all states
var states: Dictionary = {}

@export var current_state: State

func _ready() -> void:
	if attack_hitbox_collision_shape:
		attack_hitbox_collision_shape.disabled = true
	if crouch_hitbox_collision_shape:
		crouch_hitbox_collision_shape.disabled = true
	
	# Initialize states
	for child in get_children():
		if child is State:
			states[child.get_script()] = child
			child.state_machine = self
			
	# Start with Idle state, we can use the class name directly if we import it or knowing it's available
	# However, since we might not have the class definition fully separate without cyclical deps in some languages, 
	# but in GDScript 2.0 classes are global.
	change_state(StateIdle)

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func change_state(target_state_script: Script) -> void:
	var new_state = states.get(target_state_script)
	if not new_state:
		push_error("State not found for script: " + str(target_state_script))
		return
		
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()

func update_facing_direction() -> void:
	if body.velocity.x != 0:
		var direction = -1 if body.velocity.x < 0 else 1
		sprite_2d.flip_h = direction == -1
		sprite_2d.position.x = abs(sprite_2d.position.x) * direction
		if attack_hitbox:
			attack_hitbox.position.x = abs(attack_hitbox.position.x) * direction
		if crouch_attack_hitbox:
			crouch_attack_hitbox.position.x = abs(crouch_attack_hitbox.position.x) * direction
