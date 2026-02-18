@tool
extends BTAction

@export var speed: float = 100.0
@export var target_group: String = "player"

func _tick(delta: float) -> Status:
	# FIX: Rename the local variable to 'actor' to avoid hiding the built-in 'agent'
	var actor: CharacterBody2D = agent as CharacterBody2D
	
	if not actor:
		return FAILURE
	
	# 2. Find the target (Player)
	var target = actor.get_tree().get_first_node_in_group(target_group)
	if not target:
		return FAILURE 
	
	# 3. Check distance
	var distance = actor.global_position.distance_to(target.global_position)
	if distance > 300.0:
		return FAILURE 
		
	# 4. Move towards target
	var direction = (target.global_position - actor.global_position).normalized()
	actor.velocity = direction * speed
	actor.move_and_slide()
	
	return RUNNING
