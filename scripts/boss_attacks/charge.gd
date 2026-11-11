extends BossAttack

@export var charge_stop: RayCast2D
@export var tracker_component: TrackerComponent
@export var animation_component: AnimationComponent
@export var touch_damager_component: TouchDamagerComponent

@export var sprite: AnimatedSprite2D

var stored_direction: float

var getting_ready: bool = true
var ground_treads: int = 3

func attack_begun (_boss: Enemy) -> void:
	get_tree().create_timer(attack_timeout).timeout.connect(end_attack)
	
	getting_ready = true
	
	sprite.play("lower_stance")
	await sprite.animation_finished
	
	for i in ground_treads:
		sprite.play("tread_ground")
		await sprite.animation_finished
	
	
	getting_ready = false
	touch_damager_component.set_attack_box_active(true)

func handle_attack (boss: Enemy, delta: float) -> void:
	if getting_ready:
		stored_direction = tracker_component.movement_horizontal
		animation_component.handle_horizontal_flip(stored_direction,false)
		boss.velocity.x = move_toward(boss.velocity.x, 0.0, delta * 200.0)
	else:
		boss.velocity.x = move_toward(boss.velocity.x, 180.0 * stored_direction, delta * 100.0)
		touch_damager_component.damage = abs(boss.velocity.x * 0.25)
	
	if charge_stop.is_colliding():
		end_attack()

func end_attack () -> void:
	touch_damager_component.set_attack_box_active(false)
	sprite.play_backwards("lower_stance")
	super.end_attack()
