class_name BossAttack extends Node

signal attack_ended

func begin_attack (_boss: Enemy) -> void:
	pass

func handle_attack (_boss: Enemy, _delta: float) -> void:
	pass

func end_attack (_boss: Enemy) -> void:
	attack_ended.emit()
