class_name AnimationComponent extends Node

@export_subgroup("Nodes")
@export var sprite: AnimatedSprite2D
@export var nodes_to_flip : Dictionary[Node2D,Vector2] = {}

func handle_horizontal_flip(move_direction: float) -> void:
	if move_direction == 0: return
	
	for child : Node2D in nodes_to_flip:
		child.flip_h = false if move_direction > 0 else true
		child.position = nodes_to_flip[child] if move_direction > 0 else nodes_to_flip[child] * Vector2(-1,1)

func handle_move_animation(move_direction: float) -> void:
	handle_horizontal_flip(move_direction)
	
	if move_direction != 0:
		sprite.play("run")
	else:
		sprite.play("idle")

func handle_jump_animation(is_jumping: bool, is_falling: bool) -> void:
	if is_jumping:
		sprite.play("jump")
	elif is_falling:
		sprite.play("fall")
