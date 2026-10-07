extends Node2D
@onready var ui: CanvasLayer = $UI

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func _ready() -> void:
	ui.visible = true
