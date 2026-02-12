class_name Player
extends CharacterBody2D

@onready var input_component: InputComponent = $InputComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var state_machine: StateMachine = $StateMachine

func _physics_process(delta):
	input_component.CheckInputs()
	movement_component.HandleMovement(input_component, delta)
	state_machine._update(delta)
	move_and_slide()
