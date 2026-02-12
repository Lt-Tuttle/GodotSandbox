class_name Player
extends CharacterBody2D

@onready var input_component: InputComponent = $InputComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var state_machine: StateMachine = $StateMachine

func _physics_process(_delta):
	input_component.CheckInputs()
