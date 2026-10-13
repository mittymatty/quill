class_name FallDamageComponent extends Node

@export_subgroup("Nodes")
@export var health_component: HealthComponent

@export_subgroup("Configuration")
@export var min_damage_velocity: float = -300.0
@export var max_damage_velocity: float = -600.0
@export var damage_per_1_velocity: float = 0.1

var previous_y_velocity: float

func handle_fall_damage (y_velocity: float,is_immune: bool) -> void:
	var diff = y_velocity - previous_y_velocity
	
	if diff <= min_damage_velocity and !is_immune:
		var max_damage: float = max_damage_velocity * damage_per_1_velocity
		var damage_dealt: float = clampf(absf(diff)*damage_per_1_velocity,0.0,absf(max_damage))
		print(diff," ", damage_dealt)
		health_component.take_damage(damage_dealt,Vector2.ZERO,Vector2.ZERO)
	
	previous_y_velocity = y_velocity
