class_name Player
extends CharacterBody2D

@onready var input_component: InputComponent = $InputComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var state_machine: StateMachine = $StateMachine
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export var crouch_collision_shape_scale: float = 0.5
@export var crouch_collision_shape_offset: float = -7.0
@export var stand_collision_shape_scale: float = 1.0
@export var stand_collision_shape_offset: float = -14

func _process(_delta):
	input_component.CheckInputs()

func _physics_process(_delta):
	pass
