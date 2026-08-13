extends CharacterBody2D

@export var player: CharacterBody2D

@export_subgroup("Nodes")
@export var gravity_component: GravityComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var footsteps_component: FootstepsComponent
@export var hurt_component: HurtComponent
@export var tracker_component: TrackerComponent

func _ready() -> void:
	tracker_component.tracker_target = player

func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self,delta)
	movement_component.handle_horizontal_movement(self, tracker_component.movement_horizontal)
	animation_component.handle_horizontal_flip(tracker_component.movement_horizontal,false)
	animation_component.handle_move_animation(tracker_component.movement_horizontal)
	footsteps_component.handle_footstep_sound(self)
	
	move_and_slide()
