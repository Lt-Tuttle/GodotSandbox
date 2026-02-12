class_name Player
extends CharacterBody2D

@onready var movement_component: MovementComponent = $MovementComponent
@onready var input_component: InputComponent = $InputComponent
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: StateMachine = $StateMachine


func _ready():
	animation_tree.advance_expression_base_node = get_path()
	animation_tree.active = true

func _physics_process(delta):
	input_component.CheckInputs()
	state_machine._update(delta, animation_tree)
	move_and_slide()