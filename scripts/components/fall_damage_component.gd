class_name FallDamageComponent extends Node

@export_subgroup("Nodes")
@export var health_component: HealthComponent

@export_subgroup("Configuration")
@export var min_damage_velocity: float = -300.0
@export var max_damage_velocity: float = -600.0
@export var damage_per_1_velocity: float = 0.1

var previous_y_velocity: float

func handle_fall_damage (y_velocity: float) -> void:
	var diff = y_velocity - previous_y_velocity
	
	if diff <= min_damage_velocity:
		health_component.take_damage(-diff*damage_per_1_velocity,Vector2.ZERO,Vector2.ZERO)
	
	previous_y_velocity = y_velocity
