class_name StateWallSlide
extends StateBase

@export var wall_slide_friction: float = 1500.0


func enter() -> void:
    player.animation_player.play(GameConstants.ANIM_WALL_SLIDE)
    # Force facing away from wall (since input is towards wall)
    if input_component.input_horizontal != 0:
        player.pivot.scale.x = - input_component.input_horizontal

func exit() -> void:
    pass

func update(_delta: float) -> void:
    # Jump -> Wall Jump
    if input_component.consume_jump():
        wall_jump()
        return


    # Check if we are still on wall
    # Exit only if we lost contact
    if not check_wall_contact():
        state_machine.change_state(StateFalling)
        return

    # Check Ground
    if player.ground_check.is_colliding():
        state_machine.change_state(StateLanding)
        return
        

func physics_update(_delta: float) -> void:
    var current_velocity = player.velocity
    var input_dir = input_component.input_horizontal
    var facing_dir = player.pivot.scale.x
    
    # Slide Friction if holding towards wall, else plain Gravity (fall faster)
    if input_dir != 0 and sign(input_dir) != sign(facing_dir):
        player.velocity.y = move_toward(current_velocity.y, movement_component.wall_slide_speed, wall_slide_friction * _delta)
    else:
        movement_component.apply_gravity(_delta)
    
    # X Movement Logic
    # If inputting AWAY from wall, allow movement to detach
    if input_dir != 0 and sign(input_dir) == sign(facing_dir):
        movement_component.handle_velocity(input_dir, _delta)
    else:
        # Otherwise, push into wall to maintain contact
        player.velocity.x = - facing_dir * 10.0
    
    player.move_and_slide()

func wall_jump() -> void:
    var facing_dir = player.pivot.scale.x
    movement_component.perform_wall_jump(facing_dir)
    state_machine.change_state(StateJumping)

func check_wall_contact() -> bool:
    return player.is_on_wall()
