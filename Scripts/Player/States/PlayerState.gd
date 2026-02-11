class_name PlayerState
extends State

# Typed reference to the player node.
var player: CharacterBody2D
var input_component: InputComponent
var movement_component: MovementComponent
var playback: AnimationNodeStateMachinePlayback

func _ready() -> void:
	# Try to find 'CharacterBody2D' by walking up the tree first. This is safer than 'owner' in nested scenes.
	var parent = get_parent()
	while parent != null:
		if parent is CharacterBody2D:
			player = parent
			break
		parent = parent.get_parent()

	# If not found via hierarchy, fallback to owner.
	if not player and owner is CharacterBody2D:
		player = owner as CharacterBody2D
		
	assert(player != null, "PlayerState could not find a CharacterBody2D ancestor.")
	
	# Wait for player to be ready
	if not player.is_node_ready():
		await player.ready

	input_component = player.find_child("InputComponent") as InputComponent
	movement_component = player.find_child("MovementComponent") as MovementComponent
	
	var anim_tree = player.find_child("AnimationTree")
	if anim_tree:
		playback = anim_tree["parameters/playback"]
