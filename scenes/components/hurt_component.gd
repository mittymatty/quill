class_name HurtComponent extends Node

@export_subgroup("Nodes")
@export var character_body: CharacterBody2D
@export var invincibility_timer: Timer

# To be called by the damager, self harm is NOT OK
func take_damage(damage: float, knockback: Vector2) -> void:
	if !invincibility_timer.is_stopped(): return
	invincibility_timer.start()
	
	print(damage, knockback)
	character_body.velocity += knockback
	
