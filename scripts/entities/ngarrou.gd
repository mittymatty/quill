extends Enemy

@export var player: CharacterBody2D

@export_subgroup("Nodes")
@export var movement_component: MovementComponent
@export var tracker_component: TrackerComponent
@export var animation_component: AnimationComponent
@export var jump_detector_component: JumpDetectorComponent
@export var jump_component: JumpComponent

func _ready() -> void:
	super._ready()
	tracker_component.tracker_target = player

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	movement_component.handle_horizontal_movement(self,tracker_component.movement_horizontal)
	animation_component.handle_horizontal_flip(tracker_component.movement_horizontal,false)
	animation_component.handle_move_animation(tracker_component.movement_horizontal,velocity.x)
	jump_component.handle_jump(self,jump_detector_component.check_if_should_jump())
	move_and_slide()
