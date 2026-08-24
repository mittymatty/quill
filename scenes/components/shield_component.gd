class_name ShieldComponent extends Node

@export_subgroup("Configuration")
@export var damage: float = 5.0
@export var knockback: Vector2 = Vector2(50.0,-50.0)

@export_subgroup("Nodes")
@export var anim_player: AnimationPlayer
@export var cooldown_timer: Timer
@export var deflect_timer: Timer
@export var raise_sound: AudioStreamPlayer2D
@export var deflect_sound: AudioStreamPlayer2D
@export var block_sound: AudioStreamPlayer2D

var is_blocking: bool = false

var has_deflected: bool = false

#called every frame
func handle_block(wants_to_block: bool) -> void:
	if wants_to_block and !is_blocking and cooldown_timer.is_stopped():
		begin_block()
	
	if !wants_to_block and is_blocking:
		end_block()

func begin_block() -> void:
	is_blocking = true
	deflect_timer.start()

func end_block() -> void:
	if !has_deflected:
		cooldown_timer.start()
	
	is_blocking = false
