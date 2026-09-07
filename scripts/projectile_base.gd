class_name Projectile extends Area2D


var movement_direction: Vector2
var movement_angle_degrees: float
var weight: float

var initial_speed: float
var current_speed: float

func fired() -> void:
	print("fired")
	pass

func projectile_hit(body: Node2D) -> void:
	#Check if can hit this target
	print(body)
	destroy_projectile()

func destroy_projectile() -> void:
	queue_free()

func update_movement() -> void:
	pass

func _physics_process(_delta: float) -> void:
	update_movement()
