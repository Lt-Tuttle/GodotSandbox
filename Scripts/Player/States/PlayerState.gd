class_name PlayerState
extends State

var player: CharacterBody2D
var input_component: InputComponent
var movement_component: MovementComponent
var playback: AnimationNodeStateMachinePlayback

func _ready() -> void:
	await owner.ready
	
	var parent = get_parent()
	while parent != null:
		if parent is CharacterBody2D:
			player = parent
			break
		parent = parent.get_parent()

	if not player and owner is CharacterBody2D:
		player = owner as CharacterBody2D
	
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a CharacterBody2D node.")
	
	input_component = player.get_node("InputComponent") as InputComponent
	movement_component = player.get_node("MovementComponent") as MovementComponent
	
	var anim_tree = player.get_node("AnimationTree")
	if anim_tree:
		playback = anim_tree["parameters/playback"]
