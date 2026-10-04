class_name DialogEntity extends Entity

@export var player: CharacterBody2D

@export_subgroup("Nodes")
@export var dialog_component: DialogComponent
@export var animation_component: AnimationComponent
@export var tracker_component: TrackerComponent

func _ready() -> void:
	tracker_component.tracker_target = player

func _physics_process(delta: float) -> void:
	super._physics_process(delta) # Gravity
	animation_component.handle_horizontal_flip(tracker_component.movement_horizontal, false)
	dialog_component.handle_dialog(Input.is_action_just_pressed("interact"),Input.is_action_just_pressed("look_up"),Input.is_action_just_pressed("look_down"))
