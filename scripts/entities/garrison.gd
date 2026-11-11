extends Enemy

enum ATTACK_STATES {NONE,CHARGE}
var attack_state: ATTACK_STATES = ATTACK_STATES.NONE
var previous_attack_state: ATTACK_STATES = ATTACK_STATES.NONE

@export_subgroup("Configuration")
@export var possible_attacks: Dictionary[ATTACK_STATES,Timer] # Which Attack; cooldown

@export_subgroup("Nodes")
@export var weapon_auto_trigger_component: WeaponAutoTriggerComponent
@export var touch_damager_component: TouchDamagerComponent
@export var charge_stop: RayCast2D
@export var boss_attacks_component: BossAttacksComponent

var stored_movement_horizontal: float = 0.0

#region boss attacks

func set_attack_state_if_able (attack_state_to_set: ATTACK_STATES, can_switch: bool):
	if attack_state_to_set == attack_state or !can_switch: return
	previous_attack_state = attack_state
	attack_state = attack_state_to_set
	on_attack_state_changed(attack_state_to_set)

func on_attack_state_changed (new_attack_state: ATTACK_STATES) -> void:
	#print(ATTACK_STATES.keys()[attack_state])
	if new_attack_state in [ATTACK_STATES.NONE]:
		var cooldown_timer: Timer = possible_attacks.get(previous_attack_state) # Cooldown of previous attack
		cooldown_timer.start()
	if new_attack_state in [ATTACK_STATES.CHARGE]:
		stored_movement_horizontal = tracker_component.get_movement_horizontal()
	
	touch_damager_component.set_attack_box_active(new_attack_state in [ATTACK_STATES.CHARGE])

func scan_attack_state () -> void:
	if state in [States.DEAD]:
		set_attack_state_if_able(ATTACK_STATES.NONE,true)
		return
	
	for attack: ATTACK_STATES in possible_attacks:
		var cooldown_timer: Timer = possible_attacks.get(attack)
		set_attack_state_if_able(attack,cooldown_timer.is_stopped() and attack_state != attack)

func handle_attacks (delta: float) -> void:
	if attack_state in [ATTACK_STATES.CHARGE]:
		velocity.x = move_toward(velocity.x, 180.0 * stored_movement_horizontal, delta * 50.0)
		touch_damager_component.damage = abs(velocity.x * 0.25)
		set_attack_state_if_able(ATTACK_STATES.NONE,charge_stop.is_colliding())

#endregion

func _physics_process(delta: float) -> void:
	scan_states()
	gravity_component.handle_gravity(self,delta)
	
	boss_attacks_component.handle_attacks(delta)
	
	if !boss_attacks_component.is_attacking:
		weapon_auto_trigger_component.scan_and_fire_attacks()
		movement_component.handle_horizontal_movement(self, 0.0 if state in [States.DEAD] else tracker_component.get_movement_horizontal())
		animation_component.handle_horizontal_flip(tracker_component.get_movement_horizontal(),tracker_component.is_backing_up)
	
	move_and_slide()
