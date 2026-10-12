extends Control

@export var player: Quill

@onready var health_bar: HealthBar = $MarginContainer/VBoxContainer/HealthBar
@onready var energy_bar: EnergyBar = $MarginContainer/VBoxContainer/EnergyBar
@onready var bpm_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/BPM
@onready var heartbeat: Heartbeat = $MarginContainer/VBoxContainer/HBoxContainer/Pulse
@onready var exertion_label: Label = $MarginContainer/VBoxContainer/Exertion
@onready var exertion_refresh_rate: Timer = $ExertionRefreshRate
@onready var beep: AudioStreamPlayer = $Beep

var current_exertion: float = 0.0
var current_bpm: float = 0.0

func update_exertion () -> void:
	if !exertion_refresh_rate.is_stopped(): return
	exertion_refresh_rate.start()
	current_exertion = player.energy_component.exertion
	exertion_label.text = "Exertion: " + str(player.energy_component.get_exertion_percent()) + "%"

func update_bpm () -> void:
	current_bpm = player.energy_component.bpm
	bpm_label.text = "BPM: " + (str(int(current_bpm)) if !heartbeat.dead else "0")
	heartbeat.set_bpm(current_bpm)

func set_pulse_dead () -> void:
	heartbeat.set_dead(true)
	update_bpm()

func _ready() -> void:
	health_bar.body = player
	energy_bar.body = player
	update_exertion()
	update_bpm()
	heartbeat.blip.connect(beep.play)
	player.energy_component.exertion_changed.connect(update_exertion)
	player.energy_component.bpm_changed.connect(update_bpm)
	player.health_component.died.connect(set_pulse_dead)
	
