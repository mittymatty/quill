class_name HeartComponent extends Node

@export_subgroup("Configuration")
@export var resting_bpm: float = 72.0
@export var max_bpm: float = 190.0

@export_subgroup("Speeds")
@export var bpm_increase_speed: float = 2.0
@export var bpm_decrease_speed: float = 1.0

@export var resting_bpm_decrease_multiplier: float = 1.5

var dead: bool = false # to be set from function
var bpm: float = resting_bpm

var is_resting: bool = false
var bpm_rest_boost: float = 0.0

signal bpm_changed

func _ready() -> void:
	bpm = resting_bpm

func handle_heart (delta: float, exertion: float) -> void: #Called on physics process
	if dead: return
	
	var bpm_speed: float = bpm_increase_speed if exertion > 1.0 else bpm_decrease_speed
	var bpm_step: float = maxf(delta * bpm_speed, 0.0)
	var is_resting_multiplier: float = resting_bpm_decrease_multiplier if is_resting else 1.0
	
	bpm_rest_boost = bpm_rest_boost + (bpm_step * 0.005) if !is_equal_approx(bpm,resting_bpm) and is_equal_approx(bpm_speed,bpm_decrease_speed) else 0.0
	bpm = clampf(move_toward(bpm, max_bpm if exertion > 1.0 else resting_bpm, (bpm_step + bpm_rest_boost) * is_resting_multiplier), 0.0, max_bpm)
	bpm_changed.emit()

func set_bpm (new_bpm: float) -> void:
	bpm = new_bpm
	bpm_changed.emit()

func set_dead () -> void:
	dead = true
	set_bpm(0.0)

func set_is_resting (_is_resting: bool) -> void:
	is_resting = _is_resting
