extends Control

@export_subgroup("Nodes")
@export var dialog_contents_label: RichTextLabel
@export var name_label: RichTextLabel
@export var dialog_choices_container: VBoxContainer

var dialog_choice_template = preload("res://scenes/UI/dialog_choice.tscn")

var quick_char_duration: float = 0.05
var long_char_duration: float = 0.5
var long_chars: Array[String] = [".","!","?",",",";",":","-"]

func make_dialog_choices (choices: Array[String]) -> void:
	for old_choice: DialogChoice in dialog_choices_container.get_children():
		old_choice.queue_free()
	
	for choice: String in choices:
		var new_dialog_choice: DialogChoice = dialog_choice_template.instantiate()
		dialog_choices_container.add_child(new_dialog_choice)
		new_dialog_choice.set_choice_text(choice)

func update_choice_highlights (choice_to_highlight: int) -> void:
	for dialog_choice: DialogChoice in dialog_choices_container.get_children():
		dialog_choice.choice_highlight(choice_to_highlight == dialog_choices_container.get_children().find(dialog_choice))

func update_dialog_labels (character_name: String, dialog_text: String) -> void:
	visible = character_name != ""
	name_label.text = character_name
	dialog_contents_label.text = dialog_text
	typewriter_effect()

func typewriter_effect () -> void:
	PlayerStatus.is_typing_dialog = true
	dialog_contents_label.visible_characters = 0
	
	for i in dialog_contents_label.text.length():
		var wait_time: float = quick_char_duration if !dialog_contents_label.text[i] in long_chars else long_char_duration
		dialog_contents_label.visible_characters += 1
		await get_tree().create_timer(wait_time if !PlayerStatus.is_skipping_dialog else 0.0,true,false,true).timeout
	
	PlayerStatus.is_skipping_dialog = false
	PlayerStatus.is_typing_dialog = false

func reset_all_text () -> void:
	name_label.text = ""
	dialog_contents_label.text = ""
	for dialog_choice: DialogChoice in dialog_choices_container.get_children():
		dialog_choice.set_choice_text("")

func _process(_delta: float) -> void:
	dialog_choices_container.visible = !PlayerStatus.is_typing_dialog

func _ready() -> void:
	hide()
	reset_all_text()
	SignalBus.update_dialog_choices.connect(make_dialog_choices)
	SignalBus.update_dialog_choice_highlights.connect(update_choice_highlights)
	SignalBus.update_dialog.connect(update_dialog_labels)
