class_name EnergyComponent extends Node

@export_subgroup("Configuration")
@export var max_energy: float = 1000.0
@export var starter_energy: float = 500.0
@export var max_exertion: float = 10.0
@export var resting_bpm: float = 72.0
@export var exertion_increase_speed: float = 5.0
@export var exertion_decrease_speed: float = 7.0


var bpm: float = resting_bpm
var energy: float = starter_energy
var exertion: float = 0.0

var target_exertion: float = 0.0

signal energy_changed
signal exertion_changed
signal bpm_changed

func set_exertion_target (new_target_exertion: float) -> void:
	target_exertion = new_target_exertion

func handle_drainage (delta: float) -> void: #Called on physics process
	var new_exertion = move_toward(exertion,target_exertion,delta * (exertion_increase_speed if target_exertion > exertion else exertion_decrease_speed))
	if new_exertion != exertion:
		exertion = new_exertion
		exertion_changed.emit()
	
	if exertion > 0.0:
		energy = clampf(energy - (exertion * delta),0.0,max_energy)
		energy_changed.emit()

func get_exertion_percent () -> int:
	return int((exertion/max_exertion)*100.0)

func affect_exertion (affect_by: float) -> void:
	exertion = clampf(exertion + affect_by, 0.0, max_exertion)
	exertion_changed.emit()

func set_exertion (new_exertion: float) -> void:
	exertion = clampf(new_exertion, 0.0, max_exertion)
	exertion_changed.emit()

func set_energy (new_energy: float) -> void:
	energy = clampf(new_energy, 0.0, max_energy)
	energy_changed.emit()

#func handle_energy_drainage_by_exertion (delta: float) -> void:
	#set_energy(clampf(energy - (exertion * delta),0.0,max_energy))
