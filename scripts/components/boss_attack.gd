class_name BossAttack extends Node

signal attack_ended
@export var attack_timeout: float = 15.0
var boss_attacks_component: BossAttacksComponent # is set on BossAttacksComponent _ready

func attack_begun (_boss: Enemy) -> void:
	# does not run code from inherited end_attack
	get_tree().create_timer(attack_timeout).timeout.connect(end_attack)

func handle_attack (_boss: Enemy, _delta: float) -> void:
	pass

func end_attack () -> void:
	attack_ended.emit()
