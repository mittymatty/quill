#This script is 99% written by AI, but I used it as a tool to learn. I AM NOT A VIBE CODER.

class_name Heartbeat extends Line2D

@export var enabled: bool = true

@export_range(0.25, 10.0) var spacing: float = 1.0
@export_range(1.0, 1000.0) var speed: float = 80.0 # Pixels per second
@export var amp: float = 30.0
@export var change_speed: float = 20.0

@export_range(0.0, 240.0, 1.0) var bpm: float = 100.0
@export_range(1.0, 1000.0, 1.0) var waveform_width_px: float = 40.0

@onready var r_amp: float = amp
@onready var beep: AudioStreamPlayer = $Beep

var time: float = 0.0

func _process(delta: float) -> void:
	time += delta
	if !enabled: return
	
	r_amp = move_toward(r_amp, amp, change_speed * delta)

	var cycle_px := speed * 60.0 / bpm
	var active_width_px := minf(waveform_width_px, cycle_px)
	
	for i in range(points.size()):
		var x := float(i) * spacing
		var phase_x := fposmod(x + time * speed, cycle_px)

		var y := 0.0
		if phase_x < active_width_px:
			var phase := phase_x / active_width_px
			y = -r_amp * _ecg_shape(phase)

		set_point_position(i, Vector2(x, y))

func _ecg_shape(p: float) -> float:
	var p_wave := 0.12 * _gaussian(p, 0.16, 0.035)
	var q_wave := -0.15 * _gaussian(p, 0.385, 0.012)
	var r_wave := 1.00 * _gaussian(p, 0.415, 0.045)
	var s_wave := -0.30 * _gaussian(p, 0.445, 0.014)
	var t_wave := 0.32 * _gaussian(p, 0.68, 0.075)

	return p_wave + q_wave + r_wave + s_wave + t_wave

func _gaussian(x: float, center: float, new_width: float) -> float:
	return exp(-pow((x - center) / new_width, 2.0))

func set_bpm (new_bpm: float) -> void:
	bpm = new_bpm

func get_bpm () -> float:
	return bpm

func set_params(
	new_spacing: float = spacing,
	new_speed: float = speed,
	new_amp: float = amp,
	new_bpm: float = bpm,
	new_waveform_width_px: float = waveform_width_px
) -> void:
	spacing = new_spacing
	speed = new_speed
	amp = new_amp
	bpm = new_bpm
	waveform_width_px = new_waveform_width_px
