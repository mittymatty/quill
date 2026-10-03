class_name DialogComponent extends Node

@export var dialog_data: DialogDataResource

@export_subgroup("Nodes")
@export var dialog_trigger_area: Area2D


func handle_dialog (wants_to_talk: bool) -> void:
	if !wants_to_talk or !get_can_trigger(): return
	print(dialog_data.get_dialog())

func get_can_trigger () -> bool:
	return dialog_trigger_area.get_overlapping_bodies().size() > 0
