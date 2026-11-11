extends Enemy

enum BOSS_STATES {MOBILE,IMMOBILE,CHARGE,ATTACK}
enum BOSS_MOOD {AGGRO,CAUTIOUS}

@export_subgroup("Nodes")
@export var jump_detector_component: JumpDetectorComponent
@export var jump_component: JumpComponent
@export var weapon_auto_trigger_component: WeaponAutoTriggerComponent

func _physics_process(delta: float) -> void:
	scan_states()
	gravity_component.handle_gravity(self,delta)
	movement_component.handle_horizontal_movement(self,tracker_component.movement_horizontal)
	animation_component.handle_horizontal_flip(tracker_component.movement_horizontal,tracker_component.is_backing_up)
	animation_component.handle_move_animation(tracker_component.movement_horizontal,velocity.x)
	
	if tracker_component.tracker_target:
		weapon_auto_trigger_component.scan_and_fire_attacks()
	
	jump_component.handle_jump(self,jump_detector_component.check_if_should_jump())
	move_and_slide()
