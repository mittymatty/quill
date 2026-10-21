class_name BossAttacksComponent extends Node

enum CYCLE_MODES {CYCLE, RANDOM}
@export_subgroup("Configuration")
@export var attack_cycle_mode: CYCLE_MODES = CYCLE_MODES.CYCLE

var can_attack: bool = true
var is_attacking: bool = false

var current_attack: BossAttack
var attacks: Array[BossAttack]

func _ready() -> void:
	for child: Node in get_children():
		if child is BossAttack:
			attacks.append(child)

func decide_next_attack () -> void:
	var current_attack_num: int = attacks.find(current_attack)
	
	if attack_cycle_mode in [CYCLE_MODES.RANDOM]:
		current_attack = attacks.pick_random()
	elif attack_cycle_mode in [CYCLE_MODES.CYCLE]:
		current_attack = attacks[current_attack_num + 1] if attacks.size() < current_attack_num else attacks.front()

func handle_boss_attacks (boss: Enemy, delta: float) -> void: # Call in physics process
	if current_attack:
		current_attack.handle_attack(boss,delta)
	elif can_attack:
		decide_next_attack()

func set_attack_cycle_mode (new_cycle_mode: CYCLE_MODES) -> void:
	if attack_cycle_mode != new_cycle_mode:
		attack_cycle_mode = new_cycle_mode
