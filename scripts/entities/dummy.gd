extends Enemy

@export_subgroup("Nodes")
@export var movement_component: MovementComponent

func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self,delta)
	movement_component.handle_horizontal_movement(self,0.0)
	
	move_and_slide()

func _ready() -> void:
	health_component.damaged.connect(damage_flash)
