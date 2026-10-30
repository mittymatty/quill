extends Enemy

enum BOSS_STATES {MOBILE,IMMOBILE,CHARGE,ATTACK}

@export var player: CharacterBody2D
@export_subgroup("Nodes")
@export var tracker_component: TrackerComponent
@export var animation_component: AnimationComponent
@export var weapon_auto_trigger_component: WeaponAutoTriggerComponent
@export var boss_attacks_component: BossAttacksComponent

func _ready() -> void:
	super._ready()
	tracker_component.tracker_target = player

func _physics_process(delta: float) -> void:
	weapon_auto_trigger_component.scan_and_fire_attacks()
	gravity_component.handle_gravity(self,delta)
	if !boss_attacks_component.is_attacking:
		movement_component.handle_horizontal_movement(self,tracker_component.movement_horizontal)
	boss_attacks_component.handle_boss_attacks(self,delta)
	move_and_slide()
