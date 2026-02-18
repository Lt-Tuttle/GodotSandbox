class_name BaseEnemy
extends CharacterBody2D

@export_group("Components")
@export var health_component: HealthComponent
@export var movement_component: MovementComponent # Optional usage for now

@export_group("Stats")
@export var speed: float = 100.0
@export var damage: float = 10.0

func _ready() -> void:
	# Dependency Injection / Verification
	if not health_component:
		health_component = $HealthComponent
		
	if health_component:
		health_component.died.connect(_on_died)
		health_component.damaged.connect(_on_damaged)

func _physics_process(delta: float) -> void:
	move_logic(delta)
	move_and_slide()
	
	attack_logic(delta)

# Virtual Methods intended to be overridden by children
func move_logic(_delta: float) -> void:
	pass

func attack_logic(_delta: float) -> void:
	pass

# Signal Callbacks
func _on_died() -> void:
	queue_free()

func _on_damaged(_amount: float, _source: Node) -> void:
	# Optional: Flash red, play sound, knockback
	pass
