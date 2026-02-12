class_name StateRoll
extends StateBase

@export var roll_speed: float = 200.0
@export var roll_deceleration: float = 200.0 # How fast we decelerate if starting faster than roll_speed
@export var roll_gravity_multiplier: float = 0.75

var roll_direction: float = 0.0
var current_roll_speed: float = 0.0

func enter() -> void:
	# Consider initial velocity for roll speed
	# If we are moving faster than the base roll speed, we start at that higher speed
	var current_move_speed = abs(state_machine.body.velocity.x)
	if current_move_speed > roll_speed:
		current_roll_speed = current_move_speed
	else:
		current_roll_speed = roll_speed
	
	# Determine direction based on input or current facing
	var input_x = state_machine.input_component.input_horizontal
	
	if input_x != 0:
		roll_direction = sign(input_x)
	else:
		# Fallback to sprite facing if available
		# We can also check velocity if we want to preserve momentum direction when no input
		if abs(state_machine.body.velocity.x) > 10:
			roll_direction = sign(state_machine.body.velocity.x)
		else:
			roll_direction = -1.0 if state_machine.sprite_2d.flip_h else 1.0
			
	# Force facing direction update immediately for visual
	state_machine.sprite_2d.flip_h = roll_direction < 0
	
	state_machine.animation_player.play(GameConstants.ANIM_ROLL)

func exit() -> void:
	pass

func update(_delta: float) -> void:
	# End of roll
	if not state_machine.animation_player.is_playing() or state_machine.animation_player.current_animation != GameConstants.ANIM_ROLL:
		if state_machine.input_component.input_horizontal != 0:
			state_machine.change_state(StateMoving)
		else:
			state_machine.change_state(StateIdle)
			
func physics_update(delta: float) -> void:
	# Apply gravity with multiplier
	state_machine.movement_component.apply_gravity(delta, roll_gravity_multiplier)
	
	# Decelerate roll speed if it started higher than base speed
	current_roll_speed = state_machine.movement_component.get_decelerated_speed(current_roll_speed, roll_speed, roll_deceleration, delta)
	
	# Move
	state_machine.body.velocity.x = roll_direction * current_roll_speed
	state_machine.body.move_and_slide()
