extends Node2D

@onready var projectile_launcher: ProjectileLauncher = $ProjectileLauncher

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		projectile_launcher.fire_projectile(global_position,Vector2(1,0),100,45)
