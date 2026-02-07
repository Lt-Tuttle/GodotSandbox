extends CharacterBody2D

@onready var animation_component: AnimationComponent = $AnimationComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var input_component: InputComponent = $InputComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(delta):
	# Update inputs first
	input_component.CheckInputs() 
	
	# Pass the input instance to movement
	movement_component.HandleMovement(self, input_component, delta)
	
	# Pass the input instance to animation
	animation_component.HandleAnimation(animation_player, input_component, sprite, delta)
	
	# 3. Apply the movement (Godot 4 standard)
	move_and_slide()
