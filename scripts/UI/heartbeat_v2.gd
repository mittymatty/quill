class_name Heartbeat extends Line2D

@export var spacing: float = 2.0
@export var speed: float = 80.0 # Horizontal scroll speed, in pixels per second
@export var amp: float = 30.0
@export var change_speed: float = 20.0

@export_range(1.0, 1000.0, 1.0) var waveform_width_px: float = 80.0
@export_range(0.0, 2000.0, 1.0) var gap_px: float = 120.0

@onready var r_amp: float = amp

var time: float = 0.0

func _process(delta: float) -> void:
	time += delta
	r_amp = move_toward(r_amp, amp, change_speed * delta)

	var new_width := maxf(waveform_width_px, 1.0)
	var cycle_width := new_width + gap_px

	for i in points.size():
		var x := float(i) * spacing
		# The plus sign makes the waveform appear to move from right to left.
		var phase_x := fposmod(x + time * speed, cycle_width)

		var y := 0.0 # Flat baseline during the configurable gap.
		if phase_x < new_width:
			var phase := phase_x / new_width
			y = -r_amp * _ecg_shape(phase)

		set_point_position(i, Vector2(x, y))


func _ecg_shape(p: float) -> float:
	# A simple stylized P, Q, R, S, T waveform.
	var p_wave := 0.12 * _gaussian(p, 0.16, 0.035)
	var q_wave := -0.15 * _gaussian(p, 0.385, 0.012)
	#var r_wave := 1.00 * _gaussian(p, 0.415, 0.009)
	var r_wave := 1.00 * _gaussian(p, 0.415, 0.025)
	var s_wave := -0.30 * _gaussian(p, 0.445, 0.014)
	var t_wave := 0.32 * _gaussian(p, 0.68, 0.075)

	return p_wave + q_wave + r_wave + s_wave + t_wave


func _gaussian(x: float, center: float, new_width: float) -> float:
	return exp(-pow((x - center) / new_width, 2.0))


func set_params(
	new_spacing: float = spacing,
	new_speed: float = speed,
	new_amp: float = amp,
	new_gap_px: float = gap_px
) -> void:
	spacing = new_spacing
	speed = new_speed
	amp = new_amp
	gap_px = new_gap_px
