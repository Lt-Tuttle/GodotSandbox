class_name StateAttacking
extends StateBase

func enter() -> void:
    if state_machine.is_crouching:
        player.animation_player.play(GameConstants.ANIM_CROUCH_ATTACK)
    else:
        player.animation_player.play(GameConstants.ANIM_ATTACK)

func exit() -> void:
    pass

func update(_delta: float) -> void:
    # Wait for animation to finish
    if not player.animation_player.is_playing():
        state_machine.change_state(StateIdle)
        return

func physics_update(delta: float) -> void:
    movement_component.apply_gravity(delta)
    movement_component.handle_velocity(0, delta) # Friction
    player.move_and_slide()
