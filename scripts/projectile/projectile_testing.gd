extends Node2D

@onready var projectile_launcher: ProjectileLauncher = $ProjectileLauncher

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		var angle_to_mouse: float = get_angle_to(get_global_mouse_position())
		projectile_launcher.fire_projectile(projectile_launcher.global_position,Vector2.RIGHT.rotated(angle_to_mouse))
