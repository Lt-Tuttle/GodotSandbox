class_name Player
extends CharacterBody2D

@export_group("Components")
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var state_machine: StateMachine

@export_group("Visuals")
@export var animation_player: AnimationPlayer
@export var sprite_2d: Sprite2D
@export var pivot: Node2D
@export var overhead_label: Label

@export_group("Checks")
@export var wall_check: RayCast2D
@export var ledge_check: RayCast2D
@export var ledge_top_check: RayCast2D
@export var grab_position: Marker2D
@export var ground_check: RayCast2D

@export_group("Combat")
@export var attack_hitbox: Area2D
@export var crouch_attack_hitbox: Area2D
@export var attack_hitbox_collision_shape: CollisionShape2D
@export var crouch_hitbox_collision_shape: CollisionShape2D

@export_group("Collision")
@export var collision_shape: CollisionShape2D # Already here but grouping it
@export var crouch_player_collision_shape_scale: float = 0.5
@export var crouch_player_collision_shape_offset: float = -7.0
@export var stand_player_collision_shape_scale: float = 1.0
@export var stand_player_collision_shape_offset: float = -14

func _ready() -> void:
	if not input_component:
		input_component = $InputComponent
	if not movement_component:
		movement_component = $MovementComponent
	if not state_machine:
		state_machine = $StateMachine
	if not collision_shape:
		collision_shape = $CollisionShape2D
		
	# Initialize State Machine with dependencies
	state_machine.init(self, input_component, movement_component)

func _process(_delta):
	input_component.CheckInputs()

	# For Debugging
	overhead_label.text = str(state_machine.current_state)

func _physics_process(_delta):
	pass
