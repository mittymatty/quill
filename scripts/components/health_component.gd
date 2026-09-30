class_name HealthComponent extends Node

@export_subgroup("Configuration")
@export var max_health: float = 100.0
@export var knockback_multiplier: float = 1.0
@export var invulnerable: bool = false

@export_subgroup("Nodes")
@export var body: PhysicsBody2D
@export var invincibility_timer: Timer

@export_subgroup("Optional Nodes")
@export var shield_component: ShieldComponent

@onready var health: float = max_health
var dead: bool = false

signal health_changed
signal damaged (damage: float)
signal died

func get_health() -> float:
	return health

#for health-changing methods aside from damage
func affect_health(affect_by: float) -> void:
	health = clampf(health + affect_by, 0.0, max_health)
	
	if !is_zero_approx(affect_by):
		health_changed.emit()
	
	if health <= 0.0:
		dead = true
		died.emit()

func set_health(to_set_to: float) -> void:
	health = to_set_to
	health_changed.emit()

func get_is_affectable() -> bool:
	return invincibility_timer.is_stopped() and !invulnerable and !dead

func get_could_block_attack_from(from: Vector2) -> bool:
	if !shield_component: return false
	if !shield_component.shield_visuals: return false
	
	var shield_x_greater: bool = shield_component.shield_visuals.global_position > body.global_position
	
	if shield_x_greater and from.x > body.global_position.x:
		return true
	
	if !shield_x_greater and from.x < body.global_position.x:
		return true
	
	return false

func take_damage(damage: float, knockback: Vector2, from: Vector2) -> void:
	var total_knockback_multiplier: float = knockback_multiplier
	if !get_is_affectable(): return
	invincibility_timer.start()
	
	if !shield_component or !shield_component.is_blocking or !get_could_block_attack_from(from):
		affect_health(-damage)
		damaged.emit(damage)
		if shield_component and shield_component.is_blocking: # Blocking, but in wrong direction
			shield_component.break_block()
	elif shield_component: #If it gets this far, the shield is blocking
		shield_component.take_hit(1)
		if shield_component.remaining_hits <= 0:
			total_knockback_multiplier *= 1.5
	
	body.velocity += knockback * total_knockback_multiplier
