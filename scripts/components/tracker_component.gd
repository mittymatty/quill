class_name TrackerComponent extends Node

@export_subgroup("Nodes")
@export var tracker_target: Node2D
@export var tracker: Node2D
@export var drop_raycast: RayCast2D
@export var refresh_timer: Timer

@export_subgroup("Configuration")
@export var start_tracking_distance: float = 100.0
@export var stop_tracking_distance: float = 1.0

var movement_horizontal: float = 0.0

func _ready() -> void:
	refresh_timer.timeout.connect(get_axis_to_target)

func get_axis_to_target () -> void:
	if !tracker_target: return
	var target_x: float = tracker_target.global_position.x
	var self_x: float = tracker.global_position.x
	var distance: float = tracker.global_position.distance_to(tracker_target.global_position)
	
	movement_horizontal = 0.0
	
	if drop_raycast and !drop_raycast.is_colliding(): return
	if distance > start_tracking_distance or distance < stop_tracking_distance: return
	
	movement_horizontal = 1.0 if target_x > self_x else -1.0
