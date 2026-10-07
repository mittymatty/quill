extends Line2D
#class_name Heartbeat 

@export var spacing = 1.0
@export var speed = 1.0
@export var amp = 1.0
@export var change_speed = 1.0

@onready var r_amp = amp

@onready var beep: AudioStreamPlayer = $Beep

var time = 0.0

var off_frame: bool = false

func _physics_process(delta):
	time += delta
	r_amp = move_toward(r_amp, amp, change_speed * delta)
	
	for i in points.size():
		var sin_time = time * speed + i
		var t_amp = r_amp + cos(sin_time / 10) * 1.2 + sin(sin_time / 25) * 2
		
		var new_point_x: float
		var new_point_y: float

		if i == points.size() - 1:
			sin_time -= 1
			new_point_x = (i - 0.999) * spacing
			new_point_y = sin(sin_time) * r_amp / 2 + cos(sin_time / 2) * r_amp
		if i == 0:
			sin_time = time * speed + 1
			new_point_x = 0.999 * spacing
			new_point_y = sin(sin_time) * r_amp / 2 + cos(sin_time / 2 + 1) * r_amp
		else:
			new_point_x = i * spacing
			new_point_y = sin(sin_time) * r_amp / 2 + cos(sin_time / 2) * t_amp
		
		set_point_position(i,Vector2(new_point_x,new_point_y))

func set_params(new_spacing = spacing, new_speed = speed, new_amp = amp):
	spacing = new_spacing
	speed = new_speed
	amp = new_amp
