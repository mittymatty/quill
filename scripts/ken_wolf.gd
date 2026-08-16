extends Enemy

@export var player: CharacterBody2D

@export_subgroup("Nodes")
@export var gravity_component: GravityComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var health_component: HealthComponent
@export var tracker_component: TrackerComponent
@export var jump_detector_component: JumpDetectorComponent
@export var jump_component: JumpComponent

@export var visible_on_screen_enabler_2d: VisibleOnScreenEnabler2D

var dead: bool = false

func _ready() -> void:
	tracker_component.tracker_target = player
	health_component.damaged.connect(damage_flash)
	health_component.died.connect(on_health_component_died)

func _physics_process(delta: float) -> void:
	if dead:
		movement_component.handle_horizontal_movement(self,0.0)
		gravity_component.handle_gravity(self,delta)
		move_and_slide()
		return
	
	gravity_component.handle_gravity(self,delta)
	animation_component.handle_horizontal_flip(tracker_component.movement_horizontal,false)
	animation_component.handle_move_animation(tracker_component.movement_horizontal)
	movement_component.handle_horizontal_movement(self, tracker_component.movement_horizontal)
	jump_component.handle_jump(self,jump_detector_component.check_if_should_jump())
	
	move_and_slide()

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	visible_on_screen_enabler_2d.queue_free()

func on_health_component_died() -> void:
	dead = true
	animation_component.handle_move_animation(0.0)
