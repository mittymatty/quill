class_name WeaponComponent extends Node

@export_subgroup("Configuration")
@export var damage: float = 5.0
@export var knockback: Vector2 = Vector2(50.0,-50.0)

@export_subgroup("Nodes")
@export var character_body: CharacterBody2D
@export var attack_box: Area2D
@export var anim_player: AnimationPlayer
@export var cooldown_timer: Timer
@export var attack_sound: AudioStreamPlayer2D

func _ready() -> void:
	attack_box.body_entered.connect(on_attack_box_contact)

func on_attack_box_contact(body: Node2D) -> void:
	if body.health_component:
		body.health_component.take_knockback(Vector2(knockback.x + abs(character_body.velocity.x)/2 if character_body.global_position.x < body.global_position.x else -knockback.x - abs(character_body.velocity.x)/2,knockback.y))
		body.health_component.take_damage(damage)

func handle_attack(want_to_attack: bool, looking_up : bool, looking_down : bool) -> void:
	if !check_can_attack(want_to_attack): return
	var attack_type: String = decide_attack_type(looking_up, looking_down)
	anim_player.play(attack_type)
	attack_sound.play()

func check_can_attack(want_to_attack : bool) -> bool:
	return want_to_attack and !anim_player.is_playing() and cooldown_timer.is_stopped()

func decide_attack_type(looking_up: bool, looking_down: bool) -> String:
	if looking_up and !looking_down:
		return "slash"
	
	if looking_down:
		#character_body.velocity.y -= 100
		return "aerial_sweep"
	
	character_body.velocity.x += clampf(character_body.velocity.x,0.0,100.0) * 0.5
	return "jab"
