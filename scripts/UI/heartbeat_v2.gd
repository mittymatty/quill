#This script is 99% written by AI, but I used it as a tool to learn. I AM NOT A VIBE CODER.

class_name Heartbeat extends Line2D

@export var enabled: bool = true

@export_range(0.25, 10.0) var spacing: float = 1.0
@export_range(1.0, 1000.0) var speed: float = 80.0 # Pixels per second
@export var amp: float = 30.0
@export var change_speed: float = 20.0

@export_range(0.0, 240.0, 1.0) var bpm: float = 100.0
@export_range(1.0, 1000.0, 1.0) var waveform_width_px: float = 40.0
@export_range(1.0, 1000.0) var pixels_per_beat: float = 160.0

@onready var r_amp: float = amp

signal blip

var dead: bool = false
var time: float = 0.0
var scroll_offset: float = 0.0
var pulse_starts: Array[float] = []
var spawn_distance: float = 0.0

func _physics_process(delta: float) -> void:
	if !enabled: return
	
	r_amp = move_toward(r_amp, amp, change_speed * delta)
	
	var cycle_px := pixels_per_beat
	var active_width_px := minf(waveform_width_px, cycle_px)
	var scroll_speed := cycle_px * maxf(bpm, 0.0) / 60.0
	var distance := scroll_speed * delta
	var right_edge := _line_right_edge()

	# Move all pulses that already exist.
	for i in range(pulse_starts.size()):
		pulse_starts[i] -= distance
	
	# Only create pulses while alive.
	if !dead:
		spawn_distance += distance
		while spawn_distance >= cycle_px:
			spawn_distance -= cycle_px
			pulse_starts.append(right_edge - spawn_distance)
			blip.emit()
	
	# Discard pulses that have completely left the line.
	for i in range(pulse_starts.size() - 1, -1, -1):
		if pulse_starts[i] + active_width_px < 0.0:
			pulse_starts.remove_at(i)
	
	# Draw the remaining pulses.
	for i in range(points.size()):
		var x := float(i) * spacing
		var y := 0.0
	
		for pulse_start in pulse_starts:
			var local_x := x - pulse_start
			if local_x >= 0.0 and local_x < active_width_px:
				y -= r_amp * _ecg_shape(local_x / active_width_px)
	
		set_point_position(i, Vector2(x, y))

func _ready() -> void:
	var right_edge := _line_right_edge()
	var x := right_edge

	# Seed the line with the pulses already visible when the scene starts.
	while x + waveform_width_px > 0.0:
		pulse_starts.append(x)
		x -= pixels_per_beat

func _ecg_shape(p: float) -> float:
	var p_wave := 0.12 * _gaussian(p, 0.16, 0.035)
	var q_wave := -0.15 * _gaussian(p, 0.385, 0.012)
	var r_wave := 1.00 * _gaussian(p, 0.4, 0.055)
	var s_wave := -0.30 * _gaussian(p, 0.445, 0.014)
	var t_wave := 0.32 * _gaussian(p, 0.68, 0.07)

	return p_wave + q_wave + r_wave + s_wave + t_wave

func _gaussian(x: float, center: float, new_width: float) -> float:
	return exp(-pow((x - center) / new_width, 2.0))

func _line_right_edge() -> float:
	if points.is_empty():
		return 0.0
	return points[points.size() - 1].x

func set_bpm (new_bpm: float) -> void:
	bpm = new_bpm

func set_dead (is_dead: bool) -> void:
	dead = is_dead

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
