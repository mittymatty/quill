extends CharacterBody2D

@export var player: CharacterBody2D

@export_subgroup("Nodes")
@export var gravity_component: GravityComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var hurt_component: HurtComponent
@export var tracker_component: TrackerComponent
@export var jump_detector_component: JumpDetectorComponent
@export var jump_component: JumpComponent

@export var visible_on_screen_enabler_2d: VisibleOnScreenEnabler2D

func _ready() -> void:
	tracker_component.tracker_target = player

func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self,delta)
	animation_component.handle_horizontal_flip(tracker_component.movement_horizontal,false)
	animation_component.handle_move_animation(tracker_component.movement_horizontal)
	movement_component.handle_horizontal_movement(self, tracker_component.movement_horizontal)
	jump_component.handle_jump(self,jump_detector_component.check_if_should_jump())
	move_and_slide()

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	visible_on_screen_enabler_2d.queue_free()
