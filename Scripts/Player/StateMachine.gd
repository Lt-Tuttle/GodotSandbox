class_name StateMachine
extends Node

#Get all nodes
@onready var body: CharacterBody2D = get_parent()
@onready var animation_player: AnimationPlayer = body.get_node("AnimationPlayer")
@onready var sprite_2d: Sprite2D = body.get_node("Pivot/Sprite2D")

@onready var pivot: Node2D = body.get_node("Pivot")
@onready var wall_check: RayCast2D = pivot.get_node("WallCheck")
@onready var ledge_check: RayCast2D = pivot.get_node("LedgeCheck")
@onready var back_wall_check: RayCast2D = pivot.get_node("BackWallCheck")
@onready var back_ledge_check: RayCast2D = pivot.get_node("BackLedgeCheck")
@onready var ledge_top_check: RayCast2D = pivot.get_node("LedgeTopCheck")
@onready var back_ledge_top_check: RayCast2D = pivot.get_node("BackLedgeTopCheck")
@onready var grab_position: Marker2D = pivot.get_node("GrabPosition")
@onready var ground_check: RayCast2D = pivot.get_node("GroundCheck")

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

@export var current_state: StateBase

func _ready() -> void:
	attack_hitbox_collision_shape.disabled = true
	crouch_hitbox_collision_shape.disabled = true
	
	# Initialize states
	for child in get_children():
		if child is StateBase:
			states[child.get_script()] = child
			child.state_machine = self
			
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

# TODO: When rolling, you can messup the direction of the sprite compared to the hitboxes
func update_facing_direction() -> void:
	if animation_player.current_animation == GameConstants.ANIM_TURN_AROUND:
		return

	if body.velocity.x != 0:
		var direction = -1 if body.velocity.x < 0 else 1
		pivot.scale.x = direction
