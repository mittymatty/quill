class_name ShieldComponent extends Node

@export_subgroup("Configuration")
@export var damage: float = 5.0
@export var knockback: Vector2 = Vector2(50.0,-50.0)

@export_subgroup("Nodes")
@export var anim_player: AnimationPlayer
@export var shield_visuals: Node2D
@export var cooldown_timer: Timer
@export var deflect_timer: Timer
@export var deflect_delayer: Timer
@export var raise_sound: AudioStreamPlayer2D
@export var deflect_sound: AudioStreamPlayer2D
@export var block_sound: AudioStreamPlayer2D

var is_blocking: bool = false

var has_deflected: bool = false

func _ready() -> void:
	deflect_delayer.timeout.connect(start_deflect)
	deflect_timer.timeout.connect(on_deflect_timeout)

#called every frame
func handle_block(wants_to_block: bool) -> void:
	if wants_to_block and !is_blocking and cooldown_timer.is_stopped():
		begin_block()
	
	if !wants_to_block and is_blocking:
		end_block()

func begin_block() -> void:
	is_blocking = true
	anim_player.play("raise")
	deflect_delayer.start()

func end_block() -> void:
	if !has_deflected:
		cooldown_timer.start()
	
	anim_player.play_backwards("raise")
	is_blocking = false

func start_deflect() -> void:
	deflect_timer.start()
	
	if shield_visuals:
		shield_visuals.modulate.v = 15

func on_deflect_timeout() -> void:
	if shield_visuals:
		shield_visuals.modulate.ok_hsl_l = 1
