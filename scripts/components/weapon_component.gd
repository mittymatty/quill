class_name WeaponComponent extends Node

@export_subgroup("Configuration")
@export var damage: float = 5.0
@export var knockback: Vector2 = Vector2(50.0,-50.0)

@export_subgroup("Nodes")
@export var character_body: CharacterBody2D
@export var attack_box: Area2D
@export var anim_player: AnimationPlayer
@export var cooldown_timer: Timer

@export_subgroup("Optional_Nodes")
@export var attack_sound: AudioStreamPlayer2D

var current_attack_type : String

signal attack_attempted (attack_type : String)
signal attack_success (attack_type: String, damage_dealt : float)

func handle_attack(want_to_attack: bool, attack_type: String) -> void:
	if !want_to_attack or anim_player.is_playing() or !cooldown_timer.is_stopped(): return
	current_attack_type = attack_type
	anim_player.play(attack_type)
	attack_attempted.emit(attack_type)
	if attack_sound:
		attack_sound.play()

func check_is_adversary(hit_body: CharacterBody2D) -> bool:
	if "team" in hit_body or "team" in character_body: # At least one of them isn't in a team
		return true
	return hit_body.team != character_body.team

func on_attack_box_contact(hit_body: Node2D) -> void:
	var hit_health_component: HealthComponent = hit_body.health_component if "health_component" in hit_body else null #Check if hit thing has health
	
	if hit_health_component and check_is_adversary(hit_body): #Make sure it has health and isn't on our team
		var knockback_dir: Vector2 = Vector2(knockback.x + abs(character_body.velocity.x)/2 if character_body.global_position.x < hit_body.global_position.x else -knockback.x - abs(character_body.velocity.x)/2,knockback.y)
		var previous_health : float = hit_health_component.health
		hit_health_component.take_damage(damage,knockback_dir,character_body.global_position)
		
		if hit_health_component.health < previous_health: # Make sure the attack actually hurt the target
			attack_success.emit(current_attack_type, previous_health - hit_health_component.health)

func on_attack_animation_ended (_anim_name) -> void:
	current_attack_type = ""

func _ready() -> void:
	attack_box.body_entered.connect(on_attack_box_contact)
	anim_player.animation_finished.connect(on_attack_animation_ended)
