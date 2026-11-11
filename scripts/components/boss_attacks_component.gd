class_name BossAttacksComponent extends Node

enum CYCLE_MODES {CYCLE, RANDOM}

@export_subgroup("Nodes")
@export var boss: CharacterBody2D

@export_subgroup("Configuration")
@export var attack_cycle_mode: CYCLE_MODES = CYCLE_MODES.CYCLE
@export var attacks: Dictionary[BossAttack,Timer] # Attack, cooldown

var in_cooldown: bool = false
var is_attacking: bool = false

var current_attack: BossAttack
var previous_attack: BossAttack

#region switching
func set_attack_if_able (attack_to_set: BossAttack, can_switch: bool):
	if attack_to_set == current_attack or !can_switch: return
	previous_attack = current_attack
	current_attack = attack_to_set
	is_attacking = true if current_attack else false
	on_attack_changed(attack_to_set)

func on_attack_changed (new_attack : BossAttack) -> void:
	if previous_attack:
		var cooldown_timer: Timer = attacks.get(previous_attack) # Cooldown of previous attack
		cooldown_timer.start()
	
	if new_attack:
		new_attack.attack_begun(boss)

func on_attack_finished (which_attack: BossAttack) -> void:
	set_attack_if_able(null,which_attack == current_attack) #If the attack that timed out is the current one, clear attack

func scan_and_switch_attacks () -> void:
	if is_attacking: return
	
	for attack: BossAttack in attacks:
		var cooldown_timer: Timer = attacks.get(attack)
		set_attack_if_able(attack,cooldown_timer.is_stopped())
#endregion

func set_attack_cycle_mode (new_cycle_mode: CYCLE_MODES) -> void:
	if attack_cycle_mode != new_cycle_mode:
		attack_cycle_mode = new_cycle_mode

func handle_attacks (delta: float) -> void: # Call on physics process
	scan_and_switch_attacks()
	if !is_attacking: return
	current_attack.handle_attack(boss,delta)

func _ready() -> void:
	for attack: BossAttack in attacks:
		attack.boss_attacks_component = self
		attack.attack_ended.connect(on_attack_finished.bind(attack))
