class_name Enemy extends Entity

enum States {GROUND,AIR,DEAD}
var state: States = States.GROUND
var previous_state: States = States.GROUND

@export_subgroup("Configuration")
@export var target: CharacterBody2D
@export var team: String = "enemy"
@export var queue_free_on_death: bool = false

@export_subgroup("Nodes")
@export var health_component: HealthComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var tracker_component: TrackerComponent

#region states
func set_state_if_able (new_state: States, can_switch: bool) -> void:
	if !can_switch or new_state == state: return
	previous_state = state
	state = new_state
	on_state_changed(state)
	#print(States.keys()[state])

func on_state_changed (new_state: States) -> void:
	if new_state in [States.DEAD]:
		if queue_free_on_death:
			queue_free()
		else:
			set_physics_process(false)
	#Might be wise to add more here in inheriting scripts

func scan_states () -> void:
	if state in [States.DEAD]: return # Cannot automatically switch
	elif state in [States.GROUND]: # Can switch to AIR
		set_state_if_able(States.AIR, !is_on_floor())
	elif state in [States.AIR]: # Can switch to GROUND
		set_state_if_able(States.GROUND, is_on_floor())
#endregion

#region vitals
func _on_health_component_died() -> void:
	set_state_if_able(States.DEAD,true)

func _on_health_component_damaged(_damage: float) -> void:
	damage_flash()
#endregion

#region visuals
func damage_flash() -> void:
	var red_flash: Tween = create_tween()
	var white_flash: Tween = create_tween()
	
	white_flash.tween_property(self,"modulate:v",1,0.1).from(15)
	red_flash.tween_property(self, "modulate:s", 0, 0.1).from(15)
#endregion

func _physics_process(delta: float) -> void:
	super._physics_process(delta) # Gravity
	scan_states()
	movement_component.handle_horizontal_movement(self, 0.0 if state in [States.DEAD] else tracker_component.get_movement_horizontal())
	animation_component.handle_horizontal_flip(tracker_component.get_movement_horizontal(),tracker_component.is_backing_up)
	
	move_and_slide()

func _ready() -> void:
	tracker_component.tracker_target = target
