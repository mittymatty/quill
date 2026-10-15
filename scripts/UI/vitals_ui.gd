extends Control

@export var player: Quill

@onready var health_bar: HealthBar = $MarginContainer/VBoxContainer/HealthBar
@onready var energy_bar: EnergyBar = $MarginContainer/VBoxContainer/EnergyBar
@onready var bpm_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/BPM
@onready var heartbeat: Heartbeat = $MarginContainer/VBoxContainer/HBoxContainer/Pulse
@onready var exertion_label: Label = $MarginContainer/VBoxContainer/Exertion
@onready var exertion_refresh_rate: Timer = $ExertionRefreshRate
@onready var heartbeat_sound: AudioStreamPlayer = $HeartbeatSound

@onready var energy_component: EnergyComponent = player.energy_component
@onready var health_component: HealthComponent = player.health_component
@onready var heart_component: HeartComponent = player.heart_component

@onready var max_bpm: float = heart_component.max_bpm
@onready var rest_bpm: float = heart_component.resting_bpm

var off_beat: bool = false

func update_exertion () -> void:
	if !exertion_refresh_rate.is_stopped(): return
	exertion_refresh_rate.start()
	exertion_label.text = "Exertion: " + str(energy_component.get_exertion_percent()) + "%"

func play_heartbeat_sound () -> void:
	var bpm_diff: float = max_bpm - rest_bpm
	var bpm_over_rest: float = heart_component.bpm - rest_bpm
	var bpm_percent: float = bpm_over_rest/bpm_diff
	var added_cam_trauma: float = clampf(bpm_percent,0.0,0.33)
	
	off_beat = !off_beat
	heartbeat_sound.volume_db = bpm_percent * 0.2 if bpm_percent > 0.35 else -50.0
	
	if bpm_percent > 0.50:
		var flash: Tween = create_tween()
		flash.tween_property(bpm_label, "modulate", Color("ffffff"), 0.1).from(lerp(Color("ffcc00ff"),Color("ff0000"),bpm_percent))
	
	if bpm_percent > 0.75 and off_beat and player.camera.trauma < added_cam_trauma:
			player.camera.add_trauma(added_cam_trauma)
	
	heartbeat_sound.play()

func update_bpm () -> void:
	bpm_label.text = "BPM: " + (str(int(heart_component.bpm)) if !heartbeat.dead else "0")
	heartbeat.set_bpm(heart_component.bpm)

func set_pulse_dead () -> void:
	heartbeat.set_dead(true)
	update_bpm()

func _ready() -> void:
	health_bar.body = player
	energy_bar.body = player
	update_exertion()
	update_bpm()
	heartbeat.blip.connect(play_heartbeat_sound)
	energy_component.exertion_changed.connect(update_exertion)
	heart_component.bpm_changed.connect(update_bpm)
	health_component.died.connect(set_pulse_dead)
