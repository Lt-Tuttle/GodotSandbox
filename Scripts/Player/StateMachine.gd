class_name StateMachine
extends Node

#Get all nodes
@onready var body: CharacterBody2D = get_parent()
@onready var animation_player: AnimationPlayer = body.get_node("AnimationPlayer")
@onready var sprite_2d: Sprite2D = body.get_node("Sprite2D")

# Dependency Injection
@export var input_component: InputComponent
@export var movement_component: MovementComponent

# State Variables
var is_crouching: bool = false

#Get all states
var states: Dictionary = {}

@export var current_state: Node

func _ready() -> void:
	# Manual assignment if not set in editor, though export expects editor assignment usually.
	# To be safe and compatible with previous setup where Player had them as children:
	if not input_component:
		input_component = body.get_node("InputComponent")
	if not movement_component:
		movement_component = body.get_node("MovementComponent")
		
	# Initialize states
	for child in get_children():
		if child is Node:
			states[child.name.to_lower()] = child
			child.state_machine = self
			
	current_state = states.get("stateidle")
	if current_state:
		current_state.enter()

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func change_state(target_state_name: String) -> void:
	var new_state = states.get(target_state_name.to_lower())
	if not new_state:
		push_error("State not found: " + target_state_name)
		return
		
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()

func update_facing_direction() -> void:
	if body.velocity.x != 0:
		sprite_2d.flip_h = body.velocity.x < 0
		sprite_2d.position.x = 5 if body.velocity.x > 0 else -5
