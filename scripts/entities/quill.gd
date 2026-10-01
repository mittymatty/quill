class_name quill extends Entity

enum States {IDLE,RUN,DRIFT,JUMP,FALL,WALL,BALL,DEAD}
var state: States = States.IDLE
var previous_state: States = States.IDLE

@export_subgroup("Config")
@export var team: String = "player"
@export var print_state: bool = false

@export_subgroup("Nodes")
@export var camera: ShakeCamera2D
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var jump_component: AdvancedJumpComponent
@export var footsteps_component: FootstepsComponent
@export var weapon_component: WeaponComponent
@export var health_component: HealthComponent
@export var shield_component: ShieldComponent

@export_subgroup("Timers")
@export var ball_state_timer: Timer

func _ready() -> void:
	health_component.damaged.connect(add_camera_trauma)
	weapon_component.attack_success.connect(on_attack_success)
	weapon_component.attack_attempted.connect(on_attack_attempt)

func add_camera_trauma(damage_taken: float) -> void:
	camera.add_trauma(clampf(damage_taken,0.0,100.0)/50)

func on_attack_success (attack_type: String, _damage_dealt: float) -> void:
	if attack_type == "aerial_sweep" and state == States.FALL:
		jump_component.jump(self)
		ball_state_timer.start()

func on_attack_attempt (attack_type: String) -> void:
	if attack_type == "jab":
		velocity.x += clampf(velocity.x,0.0,100.0) * 0.5

func set_state() -> void:
	if is_on_floor() and !is_zero_approx(input_component.input_horizontal):
		state = States.RUN
	elif is_on_floor() and !is_zero_approx(velocity.x):
		state = States.DRIFT
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

func check_state_changed (has_state_changed: bool) -> void:
	if !has_state_changed: return
	if print_state:
		print(States.find_key(state))
	if state in [States.WALL]:
		velocity.y *= 0.1

func _physics_process(delta: float) -> void:
	previous_state = state
	set_state()
	check_state_changed(previous_state != state)
	
	jump_component.handle_jump(self,input_component.get_jump_input(),input_component.get_jump_input_held(),input_component.get_jump_input_released(),input_component.input_horizontal)
	footsteps_component.handle_footstep_sound(self)
	gravity_component.handle_gravity(self,delta) # Includes WALL gravity change
	
	if !state in [States.BALL]:
		movement_component.handle_horizontal_movement(self, input_component.input_horizontal)
	
	if !state in [States.WALL, States.BALL]:
		animation_component.handle_horizontal_flip(input_component.input_horizontal,shield_component.is_blocking)
		shield_component.handle_block(input_component.get_block_input_held())
		
		var next_attack: String = weapon_component.get_attack_type(input_component.get_up_input_held(),input_component.get_down_input_held())
		weapon_component.handle_attack(input_component.get_attack_input(),next_attack)
	
	if state in [States.IDLE,States.RUN,States.DRIFT]: #State-based animations
		ball_state_timer.stop()
		animation_component.handle_move_animation(input_component.input_horizontal, velocity.x)
	elif state in [States.JUMP,States.FALL]: #If falling or jumping
		animation_component.handle_jump_animation(jump_component.is_going_up, gravity_component.is_falling)
	elif state == States.WALL:
		camera.add_trauma(0.02)
		animation_component.handle_wall_animation()
	elif state == States.BALL:
		animation_component.handle_ball_animation()
	
	move_and_slide()
