class_name Quill extends Entity

#Data
enum States {GROUND,AIR,SLIDE,WALL,BALL,DEAD}
var state: States = States.GROUND
var previous_state: States = States.GROUND

#region components
@export_subgroup("Components")
@export var camera: ShakeCamera2D #For adding camera trauma
@export var movement_component: MovementComponent
@export var input_component: InputComponent
@export var animation_component: AnimationComponent
@export var advanced_jump_component: AdvancedJumpComponent
@export var footsteps_component: FootstepsComponent
@export var weapon_component: WeaponComponent
@export var health_component: HealthComponent
@export var shield_component: ShieldComponent
@export var energy_component: EnergyComponent
@export var slide_component: SlideComponent
@export var heart_component: HeartComponent
#endregion

#region timers
@export_subgroup("Timers")
@export var ball_state_timer: Timer
#endregion

#region visuals
@export_subgroup("Visuals")
@export var slide_dirt: GPUParticles2D
@export var run_dirt: GPUParticles2D
@export var wall_dirt: GPUParticles2D
@export var land_dirt: GPUParticles2D
@export var block_sparks: GPUParticles2D
@export var deflect_sparks: GPUParticles2D
#endregion

#Functions
#region states
func set_state_if_able (new_state: States, can_switch: bool) -> void:
	if !can_switch or new_state == state: return
	previous_state = state
	state = new_state
	on_state_changed(state)
	#print(States.find_key(state))

func scan_states () -> void:
	if state in [States.DEAD]: return # Cannot automatically switch
	elif state in [States.GROUND]: # Can switch to AIR or SLIDE
		set_state_if_able(States.AIR, !is_on_floor())
		set_state_if_able(States.SLIDE, slide_component.is_sliding)
	elif state in [States.AIR]: # Can switch to GROUND or WALL
		set_state_if_able(States.GROUND, is_on_floor())
		set_state_if_able(States.WALL, is_on_wall_only() and velocity.y > 0.0)
	elif state in [States.WALL]: # Can switch to GROUND or AIR
		set_state_if_able(States.GROUND if is_on_floor() else States.AIR, !is_on_wall() or is_on_floor() or input_component.get_jump_input())
	elif state in [States.BALL]: # Ditto
		set_state_if_able(States.GROUND if is_on_floor() else States.AIR, is_on_floor() or ball_state_timer.is_stopped())
	elif state in [States.SLIDE]:
		set_state_if_able(States.GROUND if is_on_floor() else States.AIR, !slide_component.is_sliding or !is_on_floor())

func on_state_changed (new_state: States) -> void:
	if new_state in [States.BALL]:
		ball_state_timer.start()
	if state in [States.WALL]:
		velocity.y *= 0.1
		camera.add_trauma(0.2)
	if state in [States.SLIDE]:
		camera.add_trauma(0.075)
	if state in [States.DEAD]:
		energy_component.set_dead()
		wall_dirt.emitting = false
	if state in [States.GROUND] and previous_state in [States.AIR]:
		camera.add_trauma(0.02)
		land_dirt.emitting = true # Is one-shot
	
	slide_dirt.emitting = state in [States.SLIDE]
	wall_dirt.emitting = state in [States.WALL]
#endregion

#region combat
func get_attack_type () -> String:
	if input_component.get_down_input_held():
		return "aerial_sweep"
	if input_component.get_up_input_held():
		return "slash"
	return "jab"

func _on_weapon_component_attack_success(attack_type: String, _damage_dealt: float) -> void:
	if attack_type == "aerial_sweep":
		advanced_jump_component.jump(self)
		set_state_if_able(States.BALL, true)

func _on_weapon_component_attack_attempted(attack_type: String) -> void:
	if attack_type == "jab":
		velocity.x += clampf(velocity.x,0.0,100.0) * 0.5

func _on_shield_component_deflected(prevented_damage: float) -> void:
	HitstopManager.hitstop(prevented_damage * 0.025, 0.5)
	deflect_sparks.emitting = true

func _on_shield_component_blocked(_prevented_damage: float) -> void:
	block_sparks.emitting = true
#endregion

#region vitals
func _on_health_component_damaged(damage: float) -> void:
	camera.add_trauma(clampf(damage,0.0,100.0)/50)
	HitstopManager.hitstop(damage * 0.005, 0.15)

func _on_health_component_died() -> void:
	state = States.DEAD

func _on_advanced_jump_component_jumped() -> void:
	energy_component.apply_exertion_impulse(4,0.0)

func determine_exertion () -> float:
	var is_h_input: bool = !is_zero_approx(input_component.get_input_horizontal())
	if is_h_input and state in [States.GROUND,States.AIR]:
		return abs(velocity.x * 0.05) #100 is max speed, so returns 5.0 at full speed
	return 0.0

func heart (delta) -> void:
	energy_component.set_exertion_target(determine_exertion())
	energy_component.handle_drainage(delta)
	heart_component.handle_heart(delta,energy_component.exertion)

#endregion

func animate () -> void:
	if state in [States.GROUND, States.AIR]: # Handle flip
		animation_component.handle_horizontal_flip(input_component.get_input_horizontal(),shield_component.is_blocking)
	elif state in [States.DEAD,States.BALL]:
		animation_component.handle_horizontal_flip(velocity.x,false)
	
	if state in [States.GROUND]: # Handle animations
		if input_component.get_down_input_held() and abs(velocity.x) < 10.0:
			animation_component.handle_rest_animation()
		else:
			animation_component.handle_move_animation(input_component.get_input_horizontal(),velocity.x)
	elif state in [States.AIR]:
		animation_component.handle_jump_animation(advanced_jump_component.is_going_up, gravity_component.is_falling)
	elif state in [States.BALL, States.SLIDE, States.WALL]:
		animation_component.handle_animation(States.keys()[state].to_lower())
	elif state in [States.DEAD]:
		animation_component.handle_dead_animation(!is_on_floor(),velocity.y < 0.0)
	
	run_dirt.emitting = state in [States.GROUND] and !is_zero_approx(velocity.x) # Handle particles

func _physics_process(delta: float) -> void:
	scan_states()
	gravity_component.handle_gravity(self,delta)
	heart_component.set_is_resting(state in [States.GROUND] and input_component.get_down_input_held() and abs(velocity.x) < 10.0)
	
	if state in [States.GROUND,States.AIR,States.SLIDE]:
		slide_component.handle_slide(self,delta,input_component.get_down_input(),input_component.get_down_input_held())
		weapon_component.handle_attack(input_component.get_attack_input(),get_attack_type())
		shield_component.handle_block(input_component.get_block_input_held())
	if state in [States.WALL,States.SLIDE]:
		camera.add_trauma(0.015)
	if state in [States.GROUND,States.AIR,States.WALL]:
		movement_component.handle_horizontal_movement(self,input_component.get_input_horizontal())
		advanced_jump_component.handle_jump(self,input_component.get_jump_input(),input_component.get_jump_input_held(),input_component.get_jump_input_released(),input_component.get_input_horizontal())
	if state in [States.DEAD]:
		movement_component.handle_horizontal_movement(self,0.0)
	
	heart(delta)
	animate()
	move_and_slide()
