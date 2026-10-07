class_name AnimationComponent extends Node

@export_subgroup("Nodes")
@export var sprites: Array[AnimatedSprite2D] = []
@export var nodes_to_flip : Array[Node2D] = []

@export_subgroup("Configuration")
@export var can_drift: bool = false
@export var affect_child_Z_index: bool = false

func handle_horizontal_flip(move_direction: float, direction_locked: bool) -> void:
	if is_zero_approx(move_direction) or direction_locked: return
	
	for child : Node2D in nodes_to_flip:
		var new_flip: float = 1.0 if move_direction > 0 else -1.0
		if child.scale.x == new_flip: continue
		flip_node_and_children(child,new_flip)

func play_anim_on_all_sprites(anim: String) -> void:
	for sprite: AnimatedSprite2D in sprites:
		if sprite.sprite_frames.has_animation(anim):
			sprite.play(anim)

func get_current_anim() -> String:
	return sprites.front().animation

func handle_move_animation(move_direction: float, velocity_x: float) -> void:
	
	if !is_zero_approx(move_direction):
		play_anim_on_all_sprites("run")
	elif !is_zero_approx(velocity_x) and can_drift:
		if !get_current_anim() == "drift":
			play_anim_on_all_sprites("drift")
	else:
		play_anim_on_all_sprites("idle")

func handle_jump_animation(is_jumping: bool, is_falling: bool) -> void:
	if is_jumping:
		if !get_current_anim() == "jump":
			play_anim_on_all_sprites("jump")
	elif is_falling:
		if !get_current_anim() == "fall":
			play_anim_on_all_sprites("fall")

func handle_wall_animation() -> void:
	if !get_current_anim() == "wall":
			play_anim_on_all_sprites("wall")

func handle_ball_animation() -> void:
	if !get_current_anim() == "ball":
			play_anim_on_all_sprites("ball")

func handle_dead_animation(in_air: bool, going_up: bool) -> void:
	if in_air:
		if going_up and !get_current_anim() == "dead_air_up":
			play_anim_on_all_sprites("dead_air_up")
		elif !going_up and !get_current_anim() == "dead_air_down":
			play_anim_on_all_sprites("dead_air_down")
	else:
		play_anim_on_all_sprites("dead")

func flip_node_and_children(node: Node2D, new_flip: float) -> void: # Used in handle_horizontal_flip
	node.scale.x = new_flip
	
	if !affect_child_Z_index: return
	for child: Node2D in node.get_children():
		if !child is Sprite2D and !child is AnimatedSprite2D: continue
		child.z_index *= -1
