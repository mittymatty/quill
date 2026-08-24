class_name AnimationComponent extends Node

@export_subgroup("Nodes")
@export var sprite: AnimatedSprite2D
@export var nodes_to_flip : Array[Node2D] = []

func handle_horizontal_flip(move_direction: float, direction_locked: bool) -> void:
	if is_zero_approx(move_direction) or direction_locked: return
	
	for child : Node2D in nodes_to_flip:
		var new_flip: float = 1.0 if move_direction > 0 else -1.0
		if child.scale.x == new_flip: continue
		flip_node_and_children(child,new_flip)

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

func flip_node_and_children(node: Node2D, new_flip: float) -> void:
	node.scale.x = new_flip
	
	for child: Node2D in node.get_children():
		if !child is Sprite2D and !child is AnimatedSprite2D: continue
		child.z_index *= -1
		print(child.name)
