class_name PlayerState
extends State

var player: CharacterBody2D
var input_component: InputComponent
var movement_component: MovementComponent
var playback: AnimationNodeStateMachinePlayback

func _ready() -> void:
	var parent = get_parent()
	while parent != null:
		if parent is CharacterBody2D:
			player = parent
			break
		parent = parent.get_parent()

	if not player and owner is CharacterBody2D:
		player = owner as CharacterBody2D
		
	assert(player != null, "PlayerState could not find a CharacterBody2D ancestor.")
	
	if not player.is_node_ready():
		await player.ready

	input_component = player.find_child("InputComponent") as InputComponent
	movement_component = player.find_child("MovementComponent") as MovementComponent
	
	var anim_tree = player.find_child("AnimationTree")
	if anim_tree:
		playback = anim_tree["parameters/playback"]
