extends BossAttack

@export var charge_stop: RayCast2D
@export var tracker_component: TrackerComponent
@export var animation_component: AnimationComponent
@export var touch_damager_component: TouchDamagerComponent

var stored_direction: float 

func attack_begun (boss: Enemy) -> void:
	super.attack_begun(boss)
	stored_direction = tracker_component.movement_horizontal
	animation_component.handle_horizontal_flip(stored_direction,false)
	touch_damager_component.set_attack_box_active(true)

func handle_attack (boss: Enemy, delta: float) -> void:
	print("han tak")
	boss.velocity.x = move_toward(boss.velocity.x, 180.0 * stored_direction, delta * 50.0)
	touch_damager_component.damage = abs(boss.velocity.x * 0.25)
	
	if charge_stop.is_colliding():
		end_attack()

func end_attack () -> void:
	touch_damager_component.set_attack_box_active(false)
	super.end_attack()
