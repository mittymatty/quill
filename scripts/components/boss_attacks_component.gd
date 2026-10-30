class_name BossAttacksComponent extends Node

enum CYCLE_MODES {CYCLE, RANDOM}
@export_subgroup("Configuration")
@export var attack_cycle_mode: CYCLE_MODES = CYCLE_MODES.CYCLE
@export var attack_cooldown: float = 5.0

var in_cooldown: bool = false
var is_attacking: bool = false

var current_attack: BossAttack
var attacks: Array[BossAttack]

func _ready() -> void:
	for child: Node in get_children():
		if child is BossAttack:
			attacks.append(child)
			child.attack_ended.connect(on_attack_ended.bind(child))

func decide_next_attack () -> BossAttack:
	var current_attack_num: int = attacks.find(current_attack)
	
	if attack_cycle_mode in [CYCLE_MODES.CYCLE]:
		return attacks[current_attack_num + 1] if attacks.size() < current_attack_num else attacks.front()
	elif attack_cycle_mode in [CYCLE_MODES.RANDOM]:
		return attacks.pick_random()
	else:
		return attacks.pick_random()

func wait_cooldown () -> void:
	in_cooldown = true
	await get_tree().create_timer(attack_cooldown).timeout
	in_cooldown = false

func on_attack_ended (which_attack: BossAttack) -> void:
	if which_attack == current_attack:
		current_attack = null
	wait_cooldown()

func handle_boss_attacks (boss: Enemy, delta: float) -> void: # Call in physics process
	is_attacking = current_attack != null
	if current_attack:
		current_attack.handle_attack(boss,delta)
	else:
		wait_cooldown()
		current_attack = decide_next_attack()
		current_attack.begin_attack(boss)

func set_attack_cycle_mode (new_cycle_mode: CYCLE_MODES) -> void:
	if attack_cycle_mode != new_cycle_mode:
		attack_cycle_mode = new_cycle_mode
