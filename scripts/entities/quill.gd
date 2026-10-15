class_name Quill extends Entity

enum States {IDLE,REST,RUN,SLIDE,DRIFT,JUMP,FALL,WALL,BALL,DEAD}
var state: States = States.IDLE
var previous_state: States = States.IDLE

var frozen: bool = false # Used while in dialog
var input_horizontal: float = 0.0 #Set each _physics_process

@export_subgroup("Config")
@export var team: String = "player"
@export var print_state: bool = false

@export_subgroup("Nodes")
@export var camera: ShakeCamera2D #For adding camera trauma
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var jump_component: AdvancedJumpComponent
@export var footsteps_component: FootstepsComponent
@export var weapon_component: WeaponComponent
@export var health_component: HealthComponent
@export var energy_component: EnergyComponent
@export var heart_component: HeartComponent
@export var shield_component: ShieldComponent
@export var slide_component: SlideComponent

@export_subgroup("Timers")
@export var ball_state_timer: Timer

#region vitals

func add_camera_trauma(damage_taken: float) -> void:
	camera.add_trauma(clampf(damage_taken,0.0,100.0)/40)

func on_killed () -> void:
	state = States.DEAD
	energy_component.set_dead()

func on_deflect (prevented_damage: float) -> void:
	HitstopManager.hitstop(prevented_damage * 0.025, 0.5)

func get_exertion_amount () -> float:
	if state in [States.IDLE,States.REST,States.SLIDE,States.DEAD,States.FALL]:
		return 0.0
	elif state in [States.RUN]:
		return 5.0 #Make dynamic later
	elif state in [States.DRIFT]:
		return 3.5 #Make dynamic later
	elif state in [States.JUMP]:
		return 20.0
	elif state in [States.BALL,States.WALL]:
		return 7.0
	return 0.0

#endregion

#region attack

func on_attack_success (attack_type: String, _damage_dealt: float) -> void:
	if attack_type == "aerial_sweep" and state == States.FALL:
		jump_component.jump(self)
		ball_state_timer.start()

func on_attack_attempt (attack_type: String) -> void:
	if attack_type == "jab":
		velocity.x += clampf(velocity.x,0.0,100.0) * 0.5

func get_attack_type(looking_up: bool, looking_down: bool) -> String:
	if looking_up and !looking_down:
		return "slash"
	
	if looking_down:
		return "aerial_sweep"
	
	return "jab"

#endregion

#region states

func check_state_changed (has_state_changed: bool) -> void:
	if !has_state_changed: return
	if print_state:
		print(States.find_key(state))
	if state in [States.WALL]:
		velocity.y *= 0.1

func set_state() -> void:
	if state in [States.DEAD]: return #No un-deading!
	
	if is_on_floor() and slide_component.is_sliding:
		state = States.SLIDE
	elif is_on_floor() and !is_zero_approx(input_component.input_horizontal):
		state = States.RUN
	elif is_on_floor() and !is_zero_approx(velocity.x):
		state = States.DRIFT
	elif is_on_floor() and is_zero_approx(input_component.input_horizontal) and !frozen and input_component.get_down_input_held():
		state = States.REST
	elif is_on_floor() and is_zero_approx(velocity.x):
		state = States.IDLE
	elif is_on_wall_only() and velocity.y >= 0:
		state = States.WALL
	elif !ball_state_timer.is_stopped():
		state = States.BALL
	elif !is_on_floor() and velocity.y < 0:
		state = States.JUMP
	elif !is_on_floor() and velocity.y >= 0:
		state = States.FALL

func _physics_process(delta: float) -> void:
	previous_state = state
	set_state()
	check_state_changed(previous_state != state)
	
	frozen = PlayerStatus.is_running_dialog or state in [States.DEAD]
	input_horizontal = input_component.input_horizontal if !frozen else 0.0
	
	gravity_component.handle_gravity(self,delta) # Includes WALL gravity change
	heart_component.set_is_resting(state == States.REST)
	footsteps_component.handle_footstep_sound(self)

	if !frozen:
		energy_component.set_exertion_target(get_exertion_amount())
		energy_component.handle_drainage(delta)
		heart_component.handle_heart(delta,energy_component.exertion)
		slide_component.handle_slide(self,delta,input_component.get_down_input(),input_component.get_down_input_held())
		jump_component.handle_jump(self,input_component.get_jump_input(),input_component.get_jump_input_held(),input_component.get_jump_input_released(),input_horizontal)

	if !state in [States.BALL,States.SLIDE]:
		movement_component.handle_horizontal_movement(self, input_horizontal)
	
	if !state in [States.WALL, States.BALL, States.DEAD] and !frozen:
		animation_component.handle_horizontal_flip(input_horizontal,shield_component.is_blocking)
		shield_component.handle_block(input_component.get_block_input_held() and shield_component.shield_visuals.visible)
		weapon_component.handle_attack(input_component.get_attack_input(),get_attack_type(input_component.get_up_input_held(),input_component.get_down_input_held()))
	
	if state in [States.IDLE,States.RUN,States.DRIFT]: #State-based animations
		ball_state_timer.stop()
		animation_component.handle_move_animation(input_horizontal, velocity.x)
	elif state in [States.JUMP,States.FALL]: #If falling or jumping
		animation_component.handle_jump_animation(jump_component.is_going_up, gravity_component.is_falling)
	elif state in [States.SLIDE,States.BALL]:
		animation_component.handle_animation(States.keys()[state].to_lower())
	elif state == States.WALL:
		camera.add_trauma(0.02)
		animation_component.handle_animation("wall")
	elif state == States.REST:
		animation_component.handle_rest_animation()
	elif state == States.DEAD:
		animation_component.handle_horizontal_flip(velocity.x,false)
		animation_component.handle_dead_animation(!is_on_floor(), velocity.y < 0.0)
	
	move_and_slide()

#endregion

func _ready() -> void:
	health_component.damaged.connect(add_camera_trauma)
	health_component.died.connect(on_killed)
	shield_component.deflected.connect(on_deflect)
	weapon_component.attack_success.connect(on_attack_success)
	weapon_component.attack_attempted.connect(on_attack_attempt)
