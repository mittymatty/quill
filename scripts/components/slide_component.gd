class_name SlideComponent extends Node

@export_subgroup("Nodes")
@export var slide_buffer_timer: Timer

var is_sliding: bool = false
var previous_velocity: Vector2 = Vector2.ZERO
var slide_velocity: Vector2 = Vector2.ZERO

func begin_slide () -> void:
	var impact_velo: Vector2 = previous_velocity
	is_sliding = true
	slide_velocity.x = impact_velo.y * (1.0 if previous_velocity.x > 0 else -1.0)

func slide (body: CharacterBody2D,delta: float) -> void:
	slide_velocity *= (56 * delta) #Approx. 0.96 on good frame
	body.velocity.x = slide_velocity.x

func end_slide (body: CharacterBody2D) -> void:
	body.velocity.x *= 0.5
	is_sliding = false

func handle_slide (body: CharacterBody2D, delta: float, want_to_slide: bool,slide_held: bool) -> void:
	if want_to_slide and !body.is_on_floor():
		slide_buffer_timer.start()
	
	if body.is_on_floor() and !slide_buffer_timer.is_stopped() and slide_held and !is_sliding:
		begin_slide()
	elif is_sliding and !want_to_slide and slide_held and body.is_on_floor():
		slide(body,delta)
	elif is_sliding and (!slide_held or !body.is_on_floor):
		end_slide(body)
	else:
		previous_velocity = body.velocity
