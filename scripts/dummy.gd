extends CharacterBody2D

@export_subgroup("Nodes")
@export var gravity_component: GravityComponent
@export var hurt_component: HurtComponent
@export var movement_component: MovementComponent

func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self,delta)
	movement_component.handle_horizontal_movement(self,0.0)
	
	move_and_slide()
