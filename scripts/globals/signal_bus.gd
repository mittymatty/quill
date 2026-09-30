extends Node

signal enemy_defeated (defeated_enemy: Enemy)

func emit_enemy_defeated (defeated_enemy: Enemy) -> void:
	enemy_defeated.emit(defeated_enemy)
