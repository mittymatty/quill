class_name Projectile extends Area2D

@export var movement_direction: Vector2
#@export var movement_angle_degrees: float

@export_subgroup("Configuration")
@export var weight: float
@export var x_decay: float = 0.99
@export var destroy_off_screen : bool = true

var initial_speed: float
var velocity: Vector2 = Vector2(initial_speed,0)

func fired() -> void:
	velocity.x = initial_speed

func projectile_hit(body: Node2D) -> void:
	#Check if can hit this target
	print(body)
	destroy_projectile()

func destroy_projectile() -> void:
	queue_free()

func update_movement(delta) -> void:
	velocity.x *= x_decay
	velocity.y += weight * delta
	global_position += movement_direction * velocity.x * delta
	global_position.y += velocity.y * delta

func _physics_process(delta: float) -> void:
	update_movement(delta)
	print(velocity)

func _on_life_timer_timeout() -> void:
	destroy_projectile()

func _on_body_entered(body: Node2D) -> void:
	if ! body is CharacterBody2D: # It's hit a wall
		destroy_projectile()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if destroy_off_screen:
		destroy_projectile()
