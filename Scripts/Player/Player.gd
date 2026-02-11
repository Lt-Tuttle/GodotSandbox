extends CharacterBody2D

@onready var animation_component: AnimationComponent = $AnimationComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var input_component: InputComponent = $InputComponent
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite: Sprite2D = $Sprite2D

# Helper property for AnimationTree (since expressions can't call functions)
var is_on_floor_value: bool = true

func _ready():
	# Important: Set the base node FIRST
	animation_tree.advance_expression_base_node = get_path()
	# Then activate
	animation_tree.active = true

func _physics_process(delta):
	# Update inputs first
	input_component.CheckInputs()
	
	# Pass the input instance to movement
	movement_component.HandleMovement(input_component, delta)
	
	# Apply the movement (Godot 4 standard)
	move_and_slide()
	
	# Update helper property for AnimationTree
	is_on_floor_value = is_on_floor()
	
	# Pass the animation tree to animation component
	animation_component.HandleAnimation(animation_tree, input_component, sprite, self)
