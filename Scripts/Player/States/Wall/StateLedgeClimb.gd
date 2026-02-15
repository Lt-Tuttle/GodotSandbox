class_name StateLedgeClimb
extends StateBase

var start_pos: Vector2
var target_pos: Vector2
var animation_finished: bool = false

@export var climb_height: float = 30.0 # Approximate
@export var climb_forward: float = 20.0 # Approximate

func enter() -> void:
    animation_finished = false
    start_pos = player.global_position
    
    var direction = player.pivot.scale.x
    
    target_pos = start_pos + Vector2(climb_forward * direction, -climb_height)
    
    player.animation_player.play(GameConstants.ANIM_LEDGE_CLIMB)
    
    if not player.animation_player.animation_finished.is_connected(_on_animation_finished):
        player.animation_player.animation_finished.connect(_on_animation_finished)

func exit() -> void:
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
        t = smoothstep(0.0, 1.0, t)
        player.global_position = start_pos.lerp(target_pos, t)
    
    player.velocity = Vector2.ZERO

func _on_animation_finished(anim_name: String) -> void:
    if anim_name == GameConstants.ANIM_LEDGE_CLIMB:
        animation_finished = true
