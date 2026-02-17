class_name StateLedgeClimb
extends StateBase

var start_pos: Vector2
var target_pos: Vector2
var animation_finished: bool = false

@export var climb_height: float = 28.0 # Approximate
@export var climb_forward: float = 22.0 # Approximate
@export var climb_speed_multiplier: float = 1.4

func enter() -> void:
	animation_finished = false
	start_pos = player.global_position
	
	var direction = player.pivot.scale.x
	
	target_pos = start_pos + Vector2(climb_forward * direction, -climb_height)
	
	player.animation_player.speed_scale = climb_speed_multiplier
	player.animation_player.play(GameConstants.ANIM_LEDGE_CLIMB)
	
	if not player.animation_player.animation_finished.is_connected(_on_animation_finished):
		player.animation_player.animation_finished.connect(_on_animation_finished)

func exit() -> void:
	player.animation_player.speed_scale = 1.0
	if player.animation_player.animation_finished.is_connected(_on_animation_finished):
		player.animation_player.animation_finished.disconnect(_on_animation_finished)
	
	if animation_finished:
		player.global_position = target_pos

func update(_delta: float) -> void:
	if animation_finished:
		state_machine.change_state(StateIdle)

func physics_update(_delta: float) -> void:
	var anim_length = player.animation_player.current_animation_length
	var current_time = player.animation_player.current_animation_position
	
	if anim_length > 0:
		var t = current_time / anim_length
		
		# Separate X and Y interpolation for "Up then Over" motion
		# Y axis (Up): Happens mostly in the first half (0.0 - 0.7)
		var t_y = remap(t, 0.0, 0.7, 0.0, 1.0)
		t_y = clamp(t_y, 0.0, 1.0)
		t_y = smoothstep(0.0, 1.0, t_y)
		
		# X axis (Over): Happens mostly in the second half (0.4 - 1.0)
		var t_x = remap(t, 0.4, 1.0, 0.0, 1.0)
		t_x = clamp(t_x, 0.0, 1.0)
		t_x = smoothstep(0.0, 1.0, t_x)
		
		var new_pos = Vector2.ZERO
		new_pos.x = lerp(start_pos.x, target_pos.x, t_x)
		new_pos.y = lerp(start_pos.y, target_pos.y, t_y)
		
		player.global_position = new_pos
	
	player.velocity = Vector2.ZERO

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == GameConstants.ANIM_LEDGE_CLIMB:
		animation_finished = true
