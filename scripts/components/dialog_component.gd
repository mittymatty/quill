class_name DialogComponent extends Node

@export var dialog_data: DialogDataResource

@export_subgroup("Nodes")
@export var dialog_trigger_area: Area2D

var active_dialog_key: DialogKeysResource

var is_selecting_dialog_choice: bool = false
var current_dialog_choices: int = 0 #Size of the array containing all choices
var selected_dialog_choice: int = 0 #For an array, so 0 would be the first option

signal advance_dialog_pressed

func handle_dialog (dialog_key_pressed: bool, dialog_up_pressed: bool, dialog_down_pressed: bool) -> void:
	if dialog_key_pressed and get_can_trigger():
		if !PlayerStatus.is_running_dialog:
			play_dialog()
		else:
			advance_dialog_pressed.emit()
	elif is_selecting_dialog_choice and dialog_down_pressed and selected_dialog_choice + 1 < current_dialog_choices:
		selected_dialog_choice += 1
		SignalBus.emit_update_dialog_choice_highlights(selected_dialog_choice)
	elif is_selecting_dialog_choice and dialog_up_pressed and selected_dialog_choice - 1 >= 0:
		selected_dialog_choice -= 1
		SignalBus.emit_update_dialog_choice_highlights(selected_dialog_choice)

func get_can_trigger () -> bool:
	return dialog_trigger_area.get_overlapping_bodies().size() > 0

func play_dialog () -> void:
	initialise_dialog()
	
	while active_dialog_key != null:
		var next_dialog_choices: Dictionary[String,DialogKeysResource] = active_dialog_key.choices
		play_dialog_page(active_dialog_key.dialog)
		
		if next_dialog_choices != {}:
			initialise_choices(next_dialog_choices)
		else:
			clear_choices()
		
		await advance_dialog_pressed
	
		active_dialog_key = active_dialog_key.next_dialog_key if !is_selecting_dialog_choice else next_dialog_choices[next_dialog_choices.keys()[selected_dialog_choice]]
	exit_dialog()

func initialise_dialog () -> void:
	PlayerStatus.is_running_dialog = true
	active_dialog_key = dialog_data.initial_key
	SignalBus.emit_update_dialog(dialog_data.character_name,"")

func play_dialog_page (dialog_text : String) -> void:
	SignalBus.emit_update_dialog(dialog_data.character_name,dialog_text)
	#add typewriter effect and await end

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
	is_selecting_dialog_choice = false
	SignalBus.emit_update_dialog_choices([])
	SignalBus.emit_update_dialog("","")

func _ready() -> void:
	dialog_trigger_area.body_exited.connect(area_exited)

func area_exited(_body) -> void:
	exit_dialog()
