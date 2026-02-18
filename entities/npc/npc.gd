extends CharacterBody2D

@export_category("Movement Settings")
@export var min_speed: float = 30.0
@export var max_speed: float = 80.0
@export var gravity: float = 980.0

@export_category("Behavior Settings")
@export var min_idle_time: float = 1.0
@export var max_idle_time: float = 3.0
@export var min_walk_time: float = 2.0
@export var max_walk_time: float = 5.0

@export_category("Node References")
@export var pivot: Node2D
@export var wall_check_head: RayCast2D
@export var wall_check_feet: RayCast2D
@export var ledge_check: RayCast2D
@export var animation_player: AnimationPlayer

@export_category("Sprite Sheets")
@export var body_sprites: Array[Texture2D]
@export var hair_sprites: Array[Texture2D]
@export var clothes_top_sprites: Array[Texture2D]
@export var clothes_bottom_sprites: Array[Texture2D]
@export var shoes_sprites: Array[Texture2D]

@export_category("Sprite Nodes")
@export var body_sprite: Sprite2D
@export var hair_sprite: Sprite2D
@export var clothes_top_sprite: Sprite2D
@export var clothes_bottom_sprite: Sprite2D
@export var shoes_sprite: Sprite2D


enum NPCState { IDLE, WALK }
var current_state: NPCState = NPCState.IDLE
var state_timer: float = 0.0
var current_speed: float = 0.0

var direction: Vector2 = Vector2.LEFT # Default facing left

func _ready() -> void:
	randomize_appearance()
	# Start with a random state
	pick_new_state()

func _physics_process(delta: float) -> void:
	# Apply Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle State Timer
	state_timer -= delta
	if state_timer <= 0:
		pick_new_state()

	# Handle Collision Checks (Only if moving)
	if current_state == NPCState.WALK:
		var hit_wall = false
		if wall_check_head and wall_check_head.is_colliding():
			hit_wall = true
		elif wall_check_feet and wall_check_feet.is_colliding():
			hit_wall = true
			
		var found_ledge = false
		if is_on_floor() and ledge_check and not ledge_check.is_colliding():
			found_ledge = true
			
		if hit_wall or found_ledge:
			flip_direction()
		
		# Move
		velocity.x = direction.x * current_speed
	else:
		# Idle
		velocity.x = move_toward(velocity.x, 0, 500 * delta)
	
	move_and_slide()

func pick_new_state() -> void:
	# Simple 50/50 chance to switch state, or customize logic
	if current_state == NPCState.IDLE:
		enter_walk_state()
	else:
		# If walking, chance to stop or keep walking (maybe change direction?)
		# For now, let's just flip between Walk and Idle
		enter_idle_state()

func enter_idle_state() -> void:
	current_state = NPCState.IDLE
	state_timer = randf_range(min_idle_time, max_idle_time)
	if animation_player:
		animation_player.play("IdleNPC")

func enter_walk_state() -> void:
	current_state = NPCState.WALK
	state_timer = randf_range(min_walk_time, max_walk_time)
	current_speed = randf_range(min_speed, max_speed)
	
	# Random chance to change direction when starting to walk
	if randf() > 0.5:
		flip_direction()
		
	if animation_player:
		animation_player.play("WalkNPC")

func flip_direction() -> void:
	direction.x *= -1
	
	if pivot:
		pivot.scale.x *= -1

func randomize_appearance() -> void:
	if body_sprites.size() > 0 and body_sprite:
		body_sprite.texture = body_sprites.pick_random()
	
	if hair_sprites.size() > 0 and hair_sprite:
		hair_sprite.texture = hair_sprites.pick_random()
		
	if clothes_top_sprites.size() > 0 and clothes_top_sprite:
		clothes_top_sprite.texture = clothes_top_sprites.pick_random()
		
	if clothes_bottom_sprites.size() > 0 and clothes_bottom_sprite:
		clothes_bottom_sprite.texture = clothes_bottom_sprites.pick_random()
		
	if shoes_sprites.size() > 0 and shoes_sprite:
		shoes_sprite.texture = shoes_sprites.pick_random()
