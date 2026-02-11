extends CharacterBody2D

@onready var movement_component: MovementComponent = $MovementComponent
@onready var input_component: InputComponent = $InputComponent
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite: Sprite2D = $Sprite2D

# Export path to StateMachine node (User assigns this in Editor)
@export var state_machine: StateMachine

# Helper property for AnimationTree (since expressions can't call functions)
var is_on_floor_value: bool = true

func _ready():
	# Important: Set the base node FIRST
	animation_tree.advance_expression_base_node = get_path()
	# Then activate
	animation_tree.active = true
	
	# If StateMachine is not assigned in inspector, try to find it
	if not state_machine:
		state_machine = find_child("StateMachine")

func _physics_process(delta):
	# Update inputs check is handled by states now, but we might want to ensure InputComponent is updated?
	# States call input_component.CheckInputs().
	# Update helper property for AnimationTree
	is_on_floor_value = is_on_floor()
