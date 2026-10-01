class_name WeaponAutoTriggerComponent extends Node

@export_subgroup("Nodes")
@export var target_weapon_component: WeaponComponent

@export_subgroup("Triggers")
@export var raycasts_to_trigger : Dictionary[RayCast2D,String]

func scan_and_fire_attacks () -> void: # Call on _physics_process
	var attacks_can_trigger: Array[String]
	for raycast: RayCast2D in raycasts_to_trigger:
		if raycast.is_colliding():
			attacks_can_trigger.append(raycasts_to_trigger[raycast])
	
	var can_trigger: bool = attacks_can_trigger.size() > 0
	var attack_to_trigger: String = attacks_can_trigger.front() if can_trigger else ""
	
	#if attack_to_trigger:
		#print(attack_to_trigger)
	
	target_weapon_component.handle_attack(can_trigger,attack_to_trigger)
