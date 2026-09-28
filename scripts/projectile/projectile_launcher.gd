class_name ProjectileLauncher extends Node2D

@export_subgroup("Nodes")
@export var projectile_scene: PackedScene
@export var projectile_container: Node2D

@export_subgroup("Configuration")
@export var projectile_speed: float = 150.0
@export var projectile_direction: Vector2 = Vector2.ZERO
@export var projectile_weight: float = 0.0
@export var projectile_x_decay: float = 0.995

func fire_projectile (initial_pos: Vector2, direction: Vector2) -> void:
		# Set up projectile
		var new_projectile: Projectile = projectile_scene.instantiate()
		new_projectile.movement_direction = direction.normalized()
		new_projectile.initial_speed = projectile_speed
		new_projectile.global_position = initial_pos
		new_projectile.weight = projectile_weight
		new_projectile.x_decay = projectile_x_decay
		
		projectile_container.add_child(new_projectile)
		new_projectile.fired()
		
