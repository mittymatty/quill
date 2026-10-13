class_name EnergyComponent extends Node

@export_subgroup("Configuration")
@export var max_energy: float = 1000.0
@export var starter_energy: float = 500.0
@export var max_exertion: float = 10.0

@export_subgroup("Speeds")
@export var exertion_increase_speed: float = 5.0
@export var exertion_decrease_speed: float = 7.0

var energy: float = starter_energy
var exertion: float = 0.0

var target_exertion: float = 0.0
var previous_exertion: float = exertion
var exertion_hit_zero: bool = false

var dead: bool = false # to be set from function

signal energy_changed
signal exertion_changed

func _ready() -> void:
	energy = starter_energy

func set_exertion_target (new_target_exertion: float) -> void:
	target_exertion = new_target_exertion

func handle_drainage (delta: float) -> void: #Called on physics process
	if dead: return
	var speed: float = exertion_increase_speed if target_exertion > exertion else exertion_decrease_speed
	var step: float = maxf(delta * speed, 0.0)
	
	previous_exertion = exertion
	exertion = clampf(move_toward(exertion, target_exertion, step), 0.0, max_exertion)
	exertion_changed.emit()
	
	if is_zero_approx(exertion) and !is_zero_approx(previous_exertion):
		exertion_hit_zero = true
	elif exertion != previous_exertion and exertion_hit_zero:
		exertion_hit_zero = false
	
	if exertion > 0.0:
		energy = clampf(energy - (exertion * delta),0.0,max_energy)
		energy_changed.emit()

func get_exertion_percent () -> int:
	return int(floor((exertion/max_exertion)*100.0))

func affect_exertion (affect_by: float) -> void:
	exertion = clampf(exertion + affect_by, 0.0, max_exertion)
	exertion_changed.emit()

func set_exertion (new_exertion: float) -> void:
	exertion = clampf(new_exertion, 0.0, max_exertion)
	exertion_changed.emit()

func set_energy (new_energy: float) -> void:
	energy = clampf(new_energy, 0.0, max_energy)
	energy_changed.emit()

func set_dead () -> void:
	dead = true
	set_exertion(0.0)
