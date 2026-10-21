extends Node2D
var sway_speed : float = 0.02
var screen_center : Vector2

@onready var camera_2d: Camera2D = $Camera2D

func _ready() -> void:
	screen_center = get_viewport_rect().size / 2.0

func _process(_delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var offset = (mouse_pos - screen_center) * sway_speed
	camera_2d.offset = offset
