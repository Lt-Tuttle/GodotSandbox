class_name StateLanding
extends StateBase
var min_landing_time: float = 0.1
var time_elapsed: float = 0.0

func enter() -> void:
    time_elapsed = 0.0
    
    # Buffered Jump Check
    if input_component.consume_jump():
        # Preserve momentum if jumping immediately (bunny hopping)
        movement_component.perform_jump(1.0) # Full jump power
        state_machine.change_state(StateJumping)
        return
        
    var fall_time = movement_component.fall_time
    
    if fall_time >= 0.7:
        player.animation_player.play(GameConstants.ANIM_LANDING_HEAVY)
    else:
        player.animation_player.play(GameConstants.ANIM_LANDING)

func exit() -> void:
    movement_component.fall_time = 0.0

func update(delta: float) -> void:
    time_elapsed += delta
    var current_anim = player.animation_player.current_animation
    var is_landing_anim = current_anim == GameConstants.ANIM_LANDING or current_anim == GameConstants.ANIM_LANDING_HEAVY
    
    if not player.animation_player.is_playing() or not is_landing_anim:
        if input_component.input_horizontal != 0:
            state_machine.change_state(StateMoving)
        else:
            state_machine.change_state(StateIdle)
        return

    if player.animation_player.current_animation != GameConstants.ANIM_LANDING_HEAVY:
        if input_component.consume_jump():
            var jump_power = 1.0
            if time_elapsed < min_landing_time:
                jump_power = 0.75 # Weak jump if bunny hopping
                
            movement_component.perform_jump(jump_power)
            state_machine.change_state(StateJumping)
            return
        
        if input_component.consume_roll():
            state_machine.change_state(StateRoll)
            return

        if input_component.consume_attack():
            state_machine.change_state(StateAttacking)
            return

func physics_update(delta: float) -> void:
    movement_component.handle_velocity(0, delta)
    movement_component.apply_gravity(delta)
    player.move_and_slide()
