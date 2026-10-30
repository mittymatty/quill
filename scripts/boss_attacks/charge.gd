extends BossAttack

@export var tracker_component: TrackerComponent
var direction: float 

func begin_attack (_boss: Enemy) -> void:
	super.begin_attack(_boss)
	direction = tracker_component.movement_horizontal

func handle_attack (boss: Enemy, _delta: float) -> void:
	boss.velocity.x = 500.0 * direction
	print(boss.velocity.x)
