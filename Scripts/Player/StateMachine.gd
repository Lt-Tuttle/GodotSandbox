class_name StateMachine
extends Node

# Dependency Injection
var player: Player
var input_component: InputComponent
var movement_component: MovementComponent

# State Variables
var is_crouching: bool = false

#Get all states
var states: Dictionary = {}

@export var current_state: StateBase

func init(new_player: Player, new_input: InputComponent, new_movement: MovementComponent) -> void:
	player = new_player
	input_component = new_input
	movement_component = new_movement
	
	# Initialize hitboxes (logic moved from _ready)
	if player.attack_hitbox_collision_shape:
		player.attack_hitbox_collision_shape.disabled = true
	if player.crouch_hitbox_collision_shape:
		player.crouch_hitbox_collision_shape.disabled = true
	
	# Initialize states
	for child in get_children():
		if child is StateBase:
			states[child.get_script()] = child
			child.state_machine = self
			child.init(player, input_component, movement_component)
			
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
	if player.animation_player.current_animation == GameConstants.ANIM_TURN_AROUND:
		return

	if player.is_on_wall() and input_component.input_horizontal != 0:
		player.pivot.scale.x = input_component.input_horizontal
		return

	if player.velocity.x != 0:
		var direction = -1 if player.velocity.x < 0 else 1
		player.pivot.scale.x = direction
		return
