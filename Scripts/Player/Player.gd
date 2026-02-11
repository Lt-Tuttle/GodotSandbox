extends CharacterBody2D

@onready var animation_component: AnimationComponent = $AnimationComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var input_component: InputComponent = $InputComponent
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	animation_tree.active = true
	# Important: Set the base node for advance expressions to this script (Player)
	# so the tree can access variables like velocity, input_component, etc.
	animation_tree.advance_expression_base_node = get_path()

func _physics_process(delta):
	# Update inputs first
	input_component.CheckInputs()
	
	# Pass the input instance to movement
	movement_component.HandleMovement(input_component, delta)
	
	# Apply the movement (Godot 4 standard)
	move_and_slide()
	
	# Pass the animation tree to animation component
	animation_component.HandleAnimation(animation_tree, input_component, sprite, self)
