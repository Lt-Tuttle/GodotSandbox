class_name StateLedgeClimb
extends StateBase

var start_pos: Vector2
var target_pos: Vector2
var animation_finished: bool = false

@export var climb_height: float = 30.0 # Approximate
@export var climb_forward: float = 20.0 # Approximate

func enter() -> void:
	animation_finished = false
	start_pos = state_machine.body.global_position
	
	var direction = state_machine.pivot.scale.x
	
	target_pos = start_pos + Vector2(climb_forward * direction, -climb_height)
	
	state_machine.animation_player.play(GameConstants.ANIM_LEDGE_CLIMB)
	
	if not state_machine.animation_player.animation_finished.is_connected(_on_animation_finished):
		state_machine.animation_player.animation_finished.connect(_on_animation_finished)

func exit() -> void:
	if state_machine.animation_player.animation_finished.is_connected(_on_animation_finished):
		state_machine.animation_player.animation_finished.disconnect(_on_animation_finished)
	
	if animation_finished:
		state_machine.body.global_position = target_pos

func update(_delta: float) -> void:
	if animation_finished:
		state_machine.change_state(StateIdle)

func physics_update(_delta: float) -> void:
	var anim_length = state_machine.animation_player.current_animation_length
	var current_time = state_machine.animation_player.current_animation_position
	
	if anim_length > 0:
		var t = current_time / anim_length
		t = smoothstep(0.0, 1.0, t)
		state_machine.body.global_position = start_pos.lerp(target_pos, t)
	
	state_machine.body.velocity = Vector2.ZERO

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == GameConstants.ANIM_LEDGE_CLIMB:
		animation_finished = true
