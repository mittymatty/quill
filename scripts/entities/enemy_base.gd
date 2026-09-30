class_name Enemy extends Entity

enum States {IDLE,RUN,DRIFT,JUMP,FALL,DEAD}
var state: States = States.IDLE
var previous_state: States = States.IDLE

@export var health_component: HealthComponent
@export var team: String = "enemy"
@export var queue_free_on_death: bool

func _ready() -> void:
	health_component.damaged.connect(damage_flash)
	health_component.died.connect(on_health_component_died)

func damage_flash(_damage_taken: float) -> void:
	var red_flash: Tween = create_tween()
	var white_flash: Tween = create_tween()
	
	white_flash.tween_property(self,"modulate:v",1,0.1).from(15)
	red_flash.tween_property(self, "modulate:s", 0, 0.1).from(15)

func on_health_component_died () -> void:
	state = States.DEAD
	if queue_free_on_death:
		queue_free()
	#Use super.on_health_component_died() to add more logic afterwards in child scripts
