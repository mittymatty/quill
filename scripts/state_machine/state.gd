class_name State extends Node

var state_owner: PhysicsBody2D

@warning_ignore("unused_signal")
signal switch_state(state: State)

func set_state_owner(new_owner: Node2D) -> void:
	state_owner = new_owner

func enter_state() -> void:
	pass

func exit_state() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
