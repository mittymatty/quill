class_name ProjectileLauncher extends Node2D

@export_subgroup("Nodes")
@export var projectile_scene: PackedScene
@export var projectile_container: Node2D

@export_subgroup("Configuration")
@export var projectile_speed: float = 20.0
@export var projectile__direction: Vector2 = Vector2.ZERO
@export var projectile_weight: float = 5.0

func fire_projectile (initial_pos: Vector2, direction: Vector2, desired_distance: float, desired_angle_degrees: float) -> void:
		# Set up projectile
		var new_projectile: Projectile = projectile_scene.instantiate()
		new_projectile.movement_direction = direction.normalized()
		new_projectile.movement_angle_degrees = desired_angle_degrees
		#Get initial speed based on desired distance
		new_projectile.initial_speed = pow(desired_distance * projectile_weight / sin(2 * deg_to_rad(desired_angle_degrees)),0.5)
		projectile_container.add_child(new_projectile)
		
		
