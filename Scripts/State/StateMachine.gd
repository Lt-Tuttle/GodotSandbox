class_name StateMachine
extends Node

signal transitioned(state_name)

@export var initial_state := NodePath()


var state: State

func _ready() -> void:
	if owner and not owner.is_node_ready():
		await owner.ready
		
	for child in get_children():
		child.state_machine = self
	
	if not initial_state.is_empty():
		state = get_node(initial_state)
		state.enter()

func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)

func _process(delta: float) -> void:
	state.update(delta)

func _physics_process(delta: float) -> void:
	state.physics_update(delta)

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_name):
		return

	state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)
