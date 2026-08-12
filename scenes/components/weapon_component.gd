class_name WeaponComponent extends Node

@export_subgroup("Nodes")
@export var character_body: CharacterBody2D
@export var anim_player: AnimationPlayer
@export var cooldown_timer: Timer
@export var attack_sound: AudioStreamPlayer2D

func handle_attack(want_to_attack: bool) -> void:
	if !check_can_attack(want_to_attack): return
	var attack_type = decide_attack_type()
	anim_player.play(attack_type)
	attack_sound.play()

func check_can_attack(want_to_attack : bool) -> bool:
	return want_to_attack and !anim_player.is_playing() and cooldown_timer.is_stopped()

func decide_attack_type() -> String:
	return "jab"
