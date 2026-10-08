class_name EnergyBar extends ProgressBar

@export_subgroup("Configuration")
@export var always_visible: bool = false

@export_subgroup("Nodes")
@export var body: PhysicsBody2D

var energy_component: EnergyComponent

func _ready() -> void:
	await get_tree().create_timer(0.0).timeout
	energy_component = body.energy_component
	update_bar()
	energy_component.energy_changed.connect(update_bar)

func update_bar() -> void:
	max_value = energy_component.max_energy
	value = energy_component.energy if energy_component.energy > 1.0 else 0.0
	update_visibility()

func update_visibility() -> void:
	if always_visible or value < max_value:
		show()
		return
	
	hide()
