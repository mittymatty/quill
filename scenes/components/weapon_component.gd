class_name WeaponComponent extends Node

@export_subgroup("Nodes")
@export var anim_player: AnimationPlayer
@export var cooldown_timer: Timer

func handle_attack(want_to_attack: bool) -> void:
	if !check_can_attack(want_to_attack): return
	anim_player.play(decide_attack_type())

func check_can_attack(want_to_attack : bool) -> bool:
	return want_to_attack and !anim_player.is_playing() and cooldown_timer.is_stopped()

func decide_attack_type() -> String:
	return "jab"
