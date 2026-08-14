class_name JumpDetectorComponent extends Node

@export_subgroup("Nodes")
@export var trigger_raycast: RayCast2D
@export var cooldown_timer: Timer

func check_if_should_jump() -> bool:
	if !trigger_raycast.is_colliding() or !cooldown_timer.is_stopped():
		return false
	
	cooldown_timer.start()
	return true 
