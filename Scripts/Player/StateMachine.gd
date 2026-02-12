class_name StateMachine
extends Node

#Get all nodes
@onready var body: CharacterBody2D = get_parent()
@onready var animation_player: AnimationPlayer = body.get_node("AnimationPlayer")
@onready var input_component: InputComponent = body.get_node("InputComponent")
@onready var movement_component: MovementComponent = body.get_node("MovementComponent")
@onready var sprite_2d: Sprite2D = body.get_node("Sprite2D")

#Get all states
var states: Dictionary = {}

@export var current_state: Node

func _ready() -> void:
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

func set_crouching_collision(is_crouching: bool) -> void:
	if is_crouching:
		body.get_node("CollisionShape2D").scale.y = 0.5
		body.get_node("CollisionShape2D").position.y = -7
	else:
		body.get_node("CollisionShape2D").scale.y = 1
		body.get_node("CollisionShape2D").position.y = -14
