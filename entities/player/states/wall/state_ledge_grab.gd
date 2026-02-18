class_name StateLedgeGrab
extends StateBase

var snap_tween: Tween

func enter() -> void:
    player.velocity = Vector2.ZERO
    
    snap_to_ledge()
    
    player.animation_player.play(GameConstants.ANIM_LEDGE_GRAB)

func exit() -> void:
    if snap_tween and snap_tween.is_valid():
        snap_tween.kill()

func update(_delta: float) -> void:
    if input_component.consume_crouch() or input_component.crouch_held:
        player.movement_component.lock_wall_jump()
        state_machine.change_state(StateFalling)
        return

    if input_component.consume_jump():
        var input_dir = input_component.input_horizontal
        var facing_dir = player.pivot.scale.x
        
        if input_dir != 0 and sign(input_dir) != sign(facing_dir):
            var back_dir = player.pivot.scale.x * -1
            player.movement_component.perform_wall_jump(back_dir)
            state_machine.change_state(StateJumping)
        else:
            state_machine.change_state(StateLedgeClimb)
        return

func physics_update(_delta: float) -> void:
    player.velocity = Vector2.ZERO


func snap_to_ledge() -> void:
    var wall_check = player.wall_check
    var ledge_top_check = player.ledge_top_check

    wall_check.force_raycast_update()
    ledge_top_check.force_raycast_update()

    if wall_check.is_colliding() and ledge_top_check.is_colliding():
        var wall_point = wall_check.get_collision_point()
        var ledge_point = ledge_top_check.get_collision_point()
        
        var corner_x = wall_point.x
        var corner_y = ledge_point.y
        
        var direction = player.pivot.scale.x
        
        var target_x = corner_x - (player.grab_position.position.x * direction)
        var target_y = corner_y - player.grab_position.position.y

        if snap_tween and snap_tween.is_valid():
            snap_tween.kill()
        
        snap_tween = get_tree().create_tween()
        snap_tween.tween_property(player, "global_position", Vector2(target_x, target_y), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)