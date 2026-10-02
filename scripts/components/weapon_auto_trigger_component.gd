class_name WeaponAutoTriggerComponent extends Node
enum SelectAttackBehaviour {FIRST,RANDOM}

@export_subgroup("Nodes")
@export var target_weapon_component: WeaponComponent
@export var refresh_timer: Timer

@export_subgroup("Configuration")
@export var attack_selection_behaviour: SelectAttackBehaviour

@export_subgroup("Triggers")
@export var raycasts_to_trigger : Dictionary[RayCast2D,String]

func scan_and_fire_attacks () -> void: # Call on _physics_process
	if !refresh_timer.is_stopped(): return
	refresh_timer.start()
	var attacks_can_trigger: Array[String]
	for raycast: RayCast2D in raycasts_to_trigger:
		if raycast.is_colliding():
			attacks_can_trigger.append(raycasts_to_trigger[raycast])
	
	var can_trigger: bool = attacks_can_trigger.size() > 0
	var attack_to_trigger: String = (attacks_can_trigger.front() if attack_selection_behaviour == SelectAttackBehaviour.FIRST else attacks_can_trigger.pick_random()) if can_trigger else ""
	
	target_weapon_component.handle_attack(can_trigger,attack_to_trigger)
