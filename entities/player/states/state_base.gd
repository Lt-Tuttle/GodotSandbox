class_name StateBase
extends Node

var state_machine: StateMachine
var player: Player
var input_component: InputComponent
var movement_component: MovementComponent

func init(new_player: Player, new_input_component: InputComponent, new_movement_component: MovementComponent) -> void:
	player = new_player
	input_component = new_input_component
	movement_component = new_movement_component

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
