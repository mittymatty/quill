extends BossAttack

@export var charge_stop: RayCast2D
@export var tracker_component: TrackerComponent
@export var animation_component: AnimationComponent
var direction: float 

func begin_attack (_boss: Enemy) -> void:
	super.begin_attack(_boss)
	direction = tracker_component.movement_horizontal
	animation_component.handle_horizontal_flip(direction,false)

func handle_attack (boss: Enemy, _delta: float) -> void:
	boss.velocity.x = 200.0 * direction
	if charge_stop.is_colliding():
		end_attack(boss)
