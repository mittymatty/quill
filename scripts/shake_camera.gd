class_name ShakeCamera2D extends Camera2D

@export_subgroup("Nodes")
@export var targets: Array[Node2D]

@export_subgroup("Shake Configuration")
@export var decay: float = 0.5  # How quickly the shaking stops [0, 1].
@export var max_trauma_offset: Vector2 = Vector2(10.0,10.0)  # Maximum hor/ver shake in pixels.
@export var max_roll: float = 0.1  # Maximum rotation in radians (use sparingly).

var trauma_offset: Vector2 = Vector2.ZERO
var trauma: float = 0.0  # Current shake strength.
var trauma_power: int = 2  # Trauma exponent. Use [2, 3].

@onready var base_offset: Vector2 = offset

func _ready():
	randomize()
	if targets.front() and position_smoothing_enabled: # Prevents the initial speedy camera pan
		position_smoothing_enabled = false
		global_position = targets.front().global_position
		await get_tree().create_timer(0.1).timeout
		position_smoothing_enabled = true

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)

func _process(delta):
	if targets.front():
		global_position = targets.front().global_position
		offset = base_offset + trauma_offset
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func shake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randi_range(-1, 1)
	trauma_offset.x = max_trauma_offset.x * amount * randi_range(-1, 1)
	trauma_offset.y = max_trauma_offset.y * amount * randi_range(-1, 1)
