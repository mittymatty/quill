class_name HealthComponent extends Node

@export_subgroup("Configuration")
@export var max_health: float = 100.0
@export var knockback_multiplier: float = 1.0
@export var invulnerable: bool = false

@export_subgroup("Nodes")
@export var body: PhysicsBody2D
@export var invincibility_timer: Timer

@onready var health: float = max_health
var dead: bool = false

signal health_changed
signal damaged
signal died

func get_health() -> float:
	return health

#for health-changing methods aside from damage
func affect_health(affect_by: float) -> void:
	health = clampf(health + affect_by, 0.0, max_health)
	health_changed.emit()
	
	if health <= 0.0:
		dead = true
		died.emit()

func set_health(to_set_to: float) -> void:
	health = to_set_to
	health_changed.emit()

func get_is_affectable() -> bool:
	return invincibility_timer.is_stopped() and !invulnerable and !dead

func take_damage(damage: float) -> void:
	if !get_is_affectable(): return
	invincibility_timer.start()
	
	affect_health(-damage)
	damaged.emit()

func take_knockback(knockback: Vector2) -> void:
	if dead: return
	body.velocity += knockback * knockback_multiplier
