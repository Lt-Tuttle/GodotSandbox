extends CharacterBody2D

@onready var movement_component: MovementComponent = $MovementComponent
@onready var input_component: InputComponent = $InputComponent
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite: Sprite2D = $Sprite2D

@export var state_machine: StateMachine

var is_on_floor_value: bool = true

func _ready():
	animation_tree.advance_expression_base_node = get_path()
	animation_tree.active = true
	
	if not state_machine:
		state_machine = find_child("StateMachine")

func _physics_process(delta):
	is_on_floor_value = is_on_floor()
