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

func _physics_process(delta: float) -> void:
	scan_states()
	gravity_component.handle_gravity(self,delta)
	
	if !state in [States.DEAD]:
		boss_attacks_component.handle_attacks(delta)
		weapon_auto_trigger_component.scan_and_fire_attacks()
	
	if !boss_attacks_component.is_attacking:
		movement_component.handle_horizontal_movement(self, tracker_component.get_movement_horizontal() if !state in [States.DEAD] else 0.0)
		animation_component.handle_horizontal_flip(tracker_component.get_movement_horizontal(),tracker_component.is_backing_up)
	
	move_and_slide()
