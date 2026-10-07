extends Control

@export var player: CharacterBody2D
@export var heartbeat: Heartbeat
@export var health_bar: HealthBar

func _process(_delta: float) -> void:
	pass


#func _ready() -> void:
	#health_bar.body = player
