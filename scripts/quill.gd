class_name quill extends CharacterBody2D

@export_subgroup("Nodes")
@export var state_machine: StateMachine
@export var gravity_component: GravityComponent
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var jump_component: AdvancedJumpComponent
@export var footsteps_component: FootstepsComponent
@export var weapon_component: WeaponComponent
@export var hurt_component: HurtComponent

func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self,delta)
	movement_component.handle_horizontal_movement(self, input_component.input_horizontal)
	animation_component.handle_horizontal_flip(input_component.input_horizontal,input_component.get_direction_lock_held())
	animation_component.handle_move_animation(input_component.input_horizontal)
	animation_component.handle_jump_animation(jump_component.is_going_up, gravity_component.is_falling)
	jump_component.handle_jump(self,input_component.get_jump_input(),input_component.get_jump_input_held(),input_component.get_jump_input_released())
	footsteps_component.handle_footstep_sound(self)
	weapon_component.handle_attack(input_component.get_attack_input())
	
	move_and_slide()

func _on_attackbox_body_entered(body: Node2D) -> void:
	if body.hurt_component:
		body.hurt_component.take_damage(5.0,Vector2(50.0 + abs(velocity.x)/2 if global_position.x < body.global_position.x else -50.0 - abs(velocity.x)/2,-50.0))
