class_name BossAttack extends Node

signal attack_ended
@export var attack_timeout: float = 5.0

func begin_attack (_boss: Enemy) -> void:
	get_tree().create_timer(attack_timeout).timeout.connect(end_attack.bind(_boss))

func handle_attack (_boss: Enemy, _delta: float) -> void:
	pass

func end_attack (_boss: Enemy) -> void:
	attack_ended.emit()
