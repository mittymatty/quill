class_name Quill extends CharacterBody2D

#Data
enum States {GROUND,AIR,SLIDE,WALL,BALL,DEAD}
var state: States = States.GROUND
var previous_state: States = States.GROUND

#region components
@export_subgroup("Components")
@export var camera: ShakeCamera2D #For adding camera trauma
@export var movement_component: MovementComponent
@export var input_component: InputComponent
@export var gravity_component: GravityComponent
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

#Functions
#region states
func set_state_if_able (new_state: States, can_switch: bool) -> void:
	if !can_switch or new_state == state: return
	previous_state = state
	state = new_state
	#print(States.find_key(state))
	on_state_changed(state)

func on_state_changed (new_state: States) -> void:
	if new_state in [States.BALL]:
		ball_state_timer.start()
	if state in [States.WALL]:
		velocity.y *= 0.1

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

#endregion

#region sword and shield

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

#endregion

func animate () -> void:
	if state in [States.GROUND, States.AIR]: # Handle flip
		animation_component.handle_horizontal_flip(input_component.get_input_horizontal(),shield_component.is_blocking)
	
	if state in [States.GROUND]:
		animation_component.handle_move_animation(input_component.get_input_horizontal(),velocity.x)
	elif state in [States.AIR]:
		animation_component.handle_jump_animation(velocity.y < 0.0, velocity.y > 0.0)
	elif state in [States.BALL, States.SLIDE, States.WALL]:
		animation_component.handle_animation(States.keys()[state].to_lower())
	elif state in [States.DEAD]:
		animation_component.handle_dead_animation(!is_on_floor(),velocity.y < 0.0)

func heart (delta) -> void:
	#energy_component.set_exertion_target()
	energy_component.handle_drainage(delta)
	heart_component.handle_heart(delta,energy_component.exertion)

func _physics_process(delta: float) -> void:
	scan_states()
	gravity_component.handle_gravity(self,delta)
	if state in [States.GROUND,States.AIR,States.SLIDE]:
		slide_component.handle_slide(self,delta,input_component.get_down_input(),input_component.get_down_input_held())
		weapon_component.handle_attack(input_component.get_attack_input(),get_attack_type())
		shield_component.handle_block(input_component.get_block_input_held())
	if state in [States.GROUND,States.AIR,States.WALL]:
		movement_component.handle_horizontal_movement(self,input_component.get_input_horizontal())
		advanced_jump_component.handle_jump(self,input_component.get_jump_input(),input_component.get_jump_input_held(),input_component.get_jump_input_released(),input_component.get_input_horizontal())
	
	heart(delta)
	animate()
	move_and_slide()
