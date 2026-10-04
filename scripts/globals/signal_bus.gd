extends Node

signal enemy_defeated (defeated_enemy: Enemy)

signal update_dialog (character_name: String, dialog_text: String)
signal update_dialog_choices (choices: Array[String])
signal update_dialog_choice_highlights (choice_to_highlight: int)

func emit_enemy_defeated (defeated_enemy: Enemy) -> void:
	enemy_defeated.emit(defeated_enemy)

func emit_update_dialog (character_name: String, dialog_text: String) -> void:
	update_dialog.emit(character_name, dialog_text)

func emit_update_dialog_choices (choices: Array[String]) -> void:
	update_dialog_choices.emit(choices)

func emit_update_dialog_choice_highlights (choice_to_highlight: int) -> void:
	update_dialog_choice_highlights.emit(choice_to_highlight)
