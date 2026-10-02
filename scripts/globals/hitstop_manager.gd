extends Node

func hitstop (duration : float, time_scale : float) -> void:
	Engine.time_scale = time_scale
	await get_tree().create_timer(duration,true,false,true).timeout
	Engine.time_scale = 1.0
