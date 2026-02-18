extends BaseEnemy

@export var player_check: RayCast2D

func _ready() -> void:
	super._ready()
	# Initialize specific Skeleton stuff here

func move_logic(_delta: float) -> void:
	# Placeholder AI: If we had a reference to the player, we'd move towards them.
	# For now, just apply gravity if not on floor
	if not is_on_floor():
		velocity.y += 980 * _delta
	
	# Simple patrol or idle logic could go here
	velocity.x = 0

func attack_logic(_delta: float) -> void:
	# Check if player is in range
	pass
