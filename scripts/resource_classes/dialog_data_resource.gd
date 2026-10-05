class_name DialogDataResource extends Resource

@export var character_name: String
@export var initial_key: DialogKeysResource 
@export var character_images: Dictionary[String,String] #Expression name, then filepath 

@export_subgroup("Optional")
@export var repeat_visit_initial_key: DialogKeysResource
@export var enter_command: Command
