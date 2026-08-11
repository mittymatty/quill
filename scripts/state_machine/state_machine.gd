class_name StateMachine extends Node

@export_subgroup("States")
@export var initial_state: State

var active_state: State
var previous_state: State

func _ready() -> void:
	for child_state: State in get_children():
		child_state.switch_state.connect(change_state)

func _process(delta: float) -> void: #Propogate event
	if active_state:
		active_state.update(delta)

func _physics_process(delta: float) -> void: #Propogate event
	if active_state:
		active_state.physics_update(delta)

func change_state(new_state: State) -> void:
	if new_state == active_state: return
	
	if active_state:
		active_state.exit_state()
	
	previous_state = active_state
	active_state = new_state
	
	if active_state:
		active_state.enter_state()
