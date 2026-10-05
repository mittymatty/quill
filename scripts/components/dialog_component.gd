class_name DialogComponent extends Node

@export var dialog_data: DialogDataResource

@export_subgroup("Nodes")
@export var dialog_trigger_area: Area2D

var active_dialog_key: DialogKeysResource

var is_selecting_dialog_choice: bool = false
var current_dialog_choices: int = 0 #Size of the array containing all choices
var selected_dialog_choice: int = 0 #For an array, so 0 would be the first option

var has_talked_before: bool = false

signal advance_dialog_pressed

func handle_dialog (dialog_key_pressed: bool, dialog_up_pressed: bool, dialog_down_pressed: bool) -> void:
	if dialog_key_pressed:
		if !PlayerStatus.is_running_dialog and get_can_trigger():
			play_dialog()
		elif PlayerStatus.is_running_dialog and !PlayerStatus.is_typing_dialog:
			advance_dialog_pressed.emit()
		elif PlayerStatus.is_running_dialog and PlayerStatus.is_typing_dialog:
			PlayerStatus.is_skipping_dialog = true # Skip this dialog typing but don't advance
		
	elif PlayerStatus.is_running_dialog and is_selecting_dialog_choice and (dialog_up_pressed or dialog_down_pressed):
		if dialog_up_pressed and selected_dialog_choice - 1 >= 0:
			selected_dialog_choice -= 1
		
		elif dialog_down_pressed and selected_dialog_choice + 1 < current_dialog_choices:
			selected_dialog_choice += 1
		
		SignalBus.emit_update_dialog_choice_highlights(selected_dialog_choice)

func get_can_trigger () -> bool:
	return dialog_trigger_area.get_overlapping_bodies().size() > 0

func play_dialog () -> void:
	initialise_dialog()
	
	while active_dialog_key != null:
		var next_dialog_choices: Dictionary[String,DialogKeysResource] = active_dialog_key.choices
		play_dialog_page(active_dialog_key)
		
		if next_dialog_choices != {}:
			initialise_choices(next_dialog_choices)
		else:
			clear_choices()
		
		await advance_dialog_pressed
		active_dialog_key = next_dialog_choices[next_dialog_choices.keys()[selected_dialog_choice]] if is_selecting_dialog_choice and next_dialog_choices.size() > 0 else active_dialog_key.next_dialog_key
	
	exit_dialog()

func initialise_dialog () -> void:
	PlayerStatus.is_running_dialog = true
	active_dialog_key = dialog_data.initial_key if !dialog_data.repeat_visit_initial_key or !has_talked_before else dialog_data.repeat_visit_initial_key
	has_talked_before = true
	SignalBus.emit_update_dialog(dialog_data.character_name,"")

func play_dialog_page (dialog_key: DialogKeysResource) -> void:
	SignalBus.emit_update_dialog(dialog_data.character_name,dialog_key.dialog)
	if dialog_key.enter_command:
		dialog_key.enter_command.action()

func initialise_choices (choices: Dictionary[String,DialogKeysResource]) -> void:
	var choice_strings: Array[String] = []
	is_selecting_dialog_choice = true
	current_dialog_choices = choices.size()
	selected_dialog_choice = 0
	
	for choice: String in choices:
		choice_strings.append(choice)
	
	SignalBus.emit_update_dialog_choices(choice_strings) #UI only needs to know the strings
	SignalBus.emit_update_dialog_choice_highlights(selected_dialog_choice)

func clear_choices () -> void:
	is_selecting_dialog_choice = false
	SignalBus.emit_update_dialog_choices([])

func exit_dialog() -> void:
	PlayerStatus.is_running_dialog = false
	clear_choices()
	SignalBus.emit_update_dialog("","")
