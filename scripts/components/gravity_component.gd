class_name GravityComponent extends Node

@export_subgroup("Settings")
@export var gravity: float = 980.0
@export var on_wall_multiplier: float = 1.0 # Unaffected by default

var is_falling: bool = false
var is_on_wall: bool = false

func handle_gravity(body : CharacterBody2D, delta : float) -> void:
	if !body.is_on_floor():
		body.velocity.y += (gravity * on_wall_multiplier if body.is_on_wall_only() and body.velocity.y > 0 else gravity) * delta
	
	is_falling = body.velocity.y > 0 and not body.is_on_floor()
	is_on_wall = is_falling and body.is_on_wall_only()
