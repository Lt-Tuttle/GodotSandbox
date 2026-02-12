class_name StateBase
extends Node

var state_machine # : StateMachine (Removed to fix cyclic dependency)

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
