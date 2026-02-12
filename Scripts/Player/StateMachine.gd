class_name StateMachine
extends Node

@onready var body: CharacterBody2D = get_parent()
@onready var animation_player: AnimationPlayer = body.get_node("AnimationPlayer")
@onready var input_component: InputComponent = body.get_node("InputComponent")
@onready var movement_component: MovementComponent = body.get_node("MovementComponent")
@onready var sprite_2d: Sprite2D = body.get_node("Sprite2D")

func _update(_delta: float) -> void:
	if body.velocity.x != 0:
		sprite_2d.flip_h = body.velocity.x < 0

	if body.is_on_floor():
		if input_component.crouch_pressed:
			if body.velocity.x != 0:
				if animation_player.current_animation != "CrouchWalk":
					animation_player.play("CrouchWalk")
			else:
				if animation_player.current_animation == "CrouchWalk":
					animation_player.play("Crouch")
				elif animation_player.current_animation != "Crouch" and animation_player.current_animation != "CrouchTransition":
					animation_player.play("CrouchTransition")
					animation_player.queue("Crouch")
		elif body.velocity.x != 0 and not input_component.crouch_pressed:
			if (body.velocity.x > 0 and input_component.left_pressed) or (body.velocity.x < 0 and input_component.right_pressed):
				animation_player.play("TurnAround")
			else:
				animation_player.play("Run")
		elif not input_component.crouch_pressed:
			animation_player.play("Idle")
	else:
		var jump_peak_threshold = abs(movement_component.jump_velocity * 0.1)
		
		if body.velocity.y < -jump_peak_threshold:
			animation_player.play("Jump")
		elif body.velocity.y > jump_peak_threshold:
			animation_player.play("Fall")
		else:
			animation_player.play("JumpPeak")

	if input_component.crouch_pressed:
		body.get_node("CollisionShape2D").scale.y = 0.5
		body.get_node("CollisionShape2D").position.y = -6.5
	elif input_component.crouch_released:
		body.get_node("CollisionShape2D").scale.y = 1
		body.get_node("CollisionShape2D").position.y = -13
