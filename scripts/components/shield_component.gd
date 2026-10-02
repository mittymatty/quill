class_name ShieldComponent extends Node

@export_subgroup("Configuration")
@export var max_hits_blocked: int = 3
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
@export var block_break_sound: AudioStreamPlayer2D

var remaining_hits: int = 0
var is_blocking: bool = false
var has_deflected: bool = false

signal blocked (prevented_damage: float)
signal deflected (prevented_damage: float)

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
	has_deflected = false
	is_blocking = true
	anim_player.play("raise")
	deflect_delayer.start()
	remaining_hits = max_hits_blocked
	raise_sound.play()

func end_block() -> void: #For the player to trigger
	if !has_deflected:
		cooldown_timer.start()
	
	anim_player.play_backwards("raise")
	is_blocking = false
	has_deflected = false

func start_deflect() -> void:
	deflect_timer.start()
	
	if shield_visuals:
		shield_visuals.modulate.v = 15

func on_deflect_timeout() -> void:
	if shield_visuals:
		shield_visuals.modulate.ok_hsl_l = 1

func get_is_deflecting() -> bool:
	return !deflect_timer.is_stopped()

func break_block() -> void: #For taking damage when blocking, or running out of blocks
	end_block()
	block_break_sound.play()

func take_hit(hits: int, prevented_damage: float) -> void:
	if get_is_deflecting():
		has_deflected = true
		deflected.emit(prevented_damage)
		deflect_sound.play()
		return
	
	remaining_hits -= hits
	blocked.emit(prevented_damage)
	
	if remaining_hits > 0:
		block_sound.play()
	else:
		break_block()
