class_name quill extends CharacterBody2D

enum States {IDLE,RUN,DRIFT,JUMP,FALL,WALL}
var state: States = States.IDLE

@export_subgroup("Nodes")
@export var camera: ShakeCamera2D
@export var gravity_component: GravityComponent
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var jump_component: AdvancedJumpComponent
@export var footsteps_component: FootstepsComponent
@export var weapon_component: WeaponComponent
@export var health_component: HealthComponent
@export var shield_component: ShieldComponent

func _ready() -> void:
	health_component.damaged.connect(add_camera_trauma)

func add_camera_trauma(damage_taken: float) -> void:
	camera.add_trauma(clampf(damage_taken,0.0,100.0)/50)

func set_state() -> void:
	if is_on_floor() and !is_zero_approx(input_component.input_horizontal):
		state = States.RUN
	elif is_on_floor() and !is_zero_approx(velocity.x):
		state = States.DRIFT
	elif is_on_floor() and is_zero_approx(velocity.x):
		state = States.IDLE
	elif !is_on_floor() and velocity.y < 0:
		state = States.JUMP
	elif is_on_wall_only() and velocity.y >= 0:
		state = States.WALL
	elif !is_on_floor() and velocity.y >= 0:
		state = States.FALL

func _physics_process(delta: float) -> void:
	set_state()
	
	movement_component.handle_horizontal_movement(self, input_component.input_horizontal)
	
	if state != States.WALL:
		animation_component.handle_horizontal_flip(input_component.input_horizontal,shield_component.is_blocking)
	
	jump_component.handle_jump(self,input_component.get_jump_input(),input_component.get_jump_input_held(),input_component.get_jump_input_released(),input_component.input_horizontal)
	footsteps_component.handle_footstep_sound(self)
	
	shield_component.handle_block(input_component.get_block_input_held())
	weapon_component.handle_attack(input_component.get_attack_input(),input_component.get_up_input_held(),input_component.get_down_input_held())
	
	if state in [States.IDLE,States.RUN,States.DRIFT]: #State-based animations
		animation_component.handle_move_animation(input_component.input_horizontal, velocity.x)
	elif state in [States.JUMP,States.FALL]: #If falling or jumping
		animation_component.handle_jump_animation(jump_component.is_going_up, gravity_component.is_falling)
	elif state == States.WALL:
		camera.add_trauma(0.02)
		animation_component.handle_wall_animation()
	
	gravity_component.handle_gravity(self,delta)
	move_and_slide()
