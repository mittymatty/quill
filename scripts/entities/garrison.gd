extends Enemy

enum BOSS_STATES {MOBILE,IMMOBILE,CHARGE,ATTACK}

@export var player: CharacterBody2D
@export_subgroup("Nodes")
@export var tracker_component: TrackerComponent
@export var animation_component: AnimationComponent
@export var weapon_auto_trigger_component: WeaponAutoTriggerComponent

func _physics_process(_delta: float) -> void:
	super._physics_process(_delta)
	weapon_auto_trigger_component.scan_and_fire_attacks()
