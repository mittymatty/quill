class_name AnimationComponent extends Node

@export_subgroup("Nodes")
@export var sprite: AnimatedSprite2D
@export var nodes_to_flip : Array[Node2D] = []

func handle_horizontal_flip(move_direction: float, direction_locked: bool) -> void:
	if move_direction == 0 or direction_locked: return
	
	for child : Node2D in nodes_to_flip:
		child.scale.x = 1.0 if move_direction > 0 else -1.0

func handle_move_animation(move_direction: float) -> void:
	
	if move_direction != 0:
		sprite.play("run")
	else:
		sprite.play("idle")

func handle_jump_animation(is_jumping: bool, is_falling: bool) -> void:
	if is_jumping:
		sprite.play("jump")
	elif is_falling:
		sprite.play("fall")
