extends State

@export var body: CharacterBody2D
@export var animation_component: AnimationComponent
@export var input_component: InputComponent
@export var movement_component: MovementComponent


func physics_update(_delta: float) -> void:
	var input_horizontal: float = input_component.get_input_horizontal()
	animation_component.handle_move_animation(input_horizontal,body.velocity.x)
	movement_component.handle_horizontal_movement(body,0.0)
	if !is_zero_approx(input_horizontal):
		switch_state
