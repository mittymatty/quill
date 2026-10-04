class_name DialogChoice extends NinePatchRect

@onready var dialog_choice_label: RichTextLabel = $DialogChoiceLabel
@onready var dot: TextureRect = $Dot

var not_selected_modulate: Color = Color(18.892, 18.892, 18.892)
var selected_modulate: Color = Color(12.296, 12.232, 0.0)

func set_choice_text (new_text: String) -> void:
	dialog_choice_label.text = new_text

func choice_highlight (is_enabled: bool) -> void:
	dot.modulate = selected_modulate if is_enabled else not_selected_modulate
