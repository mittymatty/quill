class_name TrackerComponent extends Node

@export_subgroup("Nodes")
@export var tracker_target: Node2D
@export var tracker: Node2D
@export var refresh_timer: Timer

@export_subgroup("Optional_Nodes")
@export var drop_raycast: RayCast2D

@export_subgroup("Configuration")
@export var start_tracking_distance: float = 100.0
@export var stop_tracking_distance: float = 1.0
@export var above_elevation_difference: float = 20.0
@export var below_elevation_difference: float = 20.0

@export_subgroup("Optional Configuration")
@export var desired_distance: float = 0.0

var movement_horizontal: float = 0.0
var distance_from_target: float = 0.0

var target_position: Vector2 = Vector2.ZERO
var target_is_above: bool = false
var target_is_below: bool = false
var is_backing_up: bool = false

func _ready() -> void:
	refresh_timer.timeout.connect(get_axis_to_target)
	await get_tree().create_timer(0.0).timeout
	change_target(tracker_target)

func on_target_dead (what_died: Node2D) -> void:
	if what_died == tracker_target:
		tracker_target = null

func change_target (new_target: Node2D) -> void:
	if tracker_target != new_target:
		tracker_target = new_target
	
	if tracker_target and "health_component" in tracker_target:
		var HC: HealthComponent = tracker_target.health_component
		HC.died.connect(on_target_dead.bind(new_target))

func get_axis_to_target () -> void:
	if !tracker_target:
		movement_horizontal = 0.0
		return
	
	var self_x: float = tracker.global_position.x
	var self_y: float = tracker.global_position.y
	target_position = tracker_target.global_position
	target_position.x += desired_distance * (-1.0 if target_position.x > self_x else 1.0)

	distance_from_target = tracker.global_position.distance_to(target_position)
	is_backing_up = distance_from_target < desired_distance if desired_distance > 0.0 else false
	target_is_above = target_position.y <= self_y - above_elevation_difference
	target_is_below = target_position.y >= self_y + below_elevation_difference
	
	if drop_raycast and !drop_raycast.is_colliding(): return
	if distance_from_target > start_tracking_distance or distance_from_target < stop_tracking_distance: return
	
	movement_horizontal = (1.0 if target_position.x > self_x else -1.0)
