class_name HealthComponent
extends Node

signal health_changed(new_health: float, max_health: float)
signal damaged(amount: float, source: Node)
signal died()

@export var max_health: float = 100.0
var current_health: float

func _ready() -> void:
	current_health = max_health

func take_damage(amount: float, source: Node = null) -> void:
	current_health -= amount
	current_health = max(current_health, 0.0) # Prevent negative health
	
	health_changed.emit(current_health, max_health)
	damaged.emit(amount, source)
	
	if current_health <= 0:
		died.emit()

func heal(amount: float) -> void:
	current_health += amount
	current_health = min(current_health, max_health) # Cap at max health
	
	health_changed.emit(current_health, max_health)
