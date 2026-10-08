extends Control

@export var player: Quill
@export var heartbeat: Heartbeat
@export var health_bar: HealthBar
@export var energy_bar: EnergyBar
@export var bpm_label: Label
@export var exertion_label: Label
@export var exertion_refresh_rate: Timer

var current_exertion: float = 0.0
var current_bpm: float = 0.0

func update_exertion () -> void:
	if !exertion_refresh_rate.is_stopped(): return
	exertion_refresh_rate.start()
	current_exertion = player.energy_component.exertion
	exertion_label.text = "Exertion: " + str(snappedf(current_exertion,0.1)) #str(player.energy_component.get_exertion_percent()) + "%"

func update_bpm () -> void:
	current_bpm = player.energy_component.bpm
	bpm_label.text = "BPM: " + str(int(current_bpm))
	heartbeat.set_bpm(current_bpm)

func _ready() -> void:
	health_bar.body = player
	energy_bar.body = player
	update_exertion()
	update_bpm()
	player.energy_component.exertion_changed.connect(update_exertion)
	player.energy_component.bpm_changed.connect(update_bpm)
