class_name DialogKeysResource extends Resource

@export var dialog: String
@export var facial_expression: String

@export var next_dialog_key: DialogKeysResource

@export_subgroup("Optional")
@export var choices: Dictionary[String, DialogKeysResource]
@export var enter_command: Command
