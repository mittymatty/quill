class_name Entity extends CharacterBody2D

@export_subgroup("Entity Nodes")
@export var gravity_component: GravityComponent

func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self,delta)
	move_and_slide()
