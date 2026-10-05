class_name DialogEntity extends Entity

@export var player: CharacterBody2D

@export_subgroup("Nodes")
@export var dialog_component: DialogComponent
@export var animation_component: AnimationComponent
@export var tracker_component: TrackerComponent
@export var input_component: InputComponent

func _ready() -> void:
	tracker_component.tracker_target = player

func _physics_process(delta: float) -> void:
	super._physics_process(delta) # Gravity
	animation_component.handle_horizontal_flip(tracker_component.movement_horizontal, false)
	dialog_component.handle_dialog(input_component.get_interact_input(),input_component.get_up_input(),input_component.get_down_input())
