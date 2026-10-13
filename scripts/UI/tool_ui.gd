extends Control

@export var player: Quill

@onready var shield_component: ShieldComponent = player.shield_component
@onready var block_icons: HBoxContainer = $MarginContainer/VBoxContainer/BlockIcons

var block_icon: PackedScene = preload("uid://cc3hwamo00yih") #This is a TextureRect
var block_icon_healthy_modulation: Color = Color("ffffff")
var block_icon_spent_modulation: Color = Color("cccccc78")

func create_icons () -> void:
	for i: int in shield_component.max_hits_blocked:
		var new_icon: TextureRect = block_icon.instantiate()
		new_icon.name = new_icon.name + str(i + 1)
		block_icons.add_child(new_icon)

func hit_taken (_damage: float) -> void:
	var icons: Array[Node] = block_icons.get_children()
	var hits_left: int = shield_component.remaining_hits
	icons.reverse() # Make them go down in the right order
	
	for i: int in range(icons.size()):
		icons[i].modulate = block_icon_spent_modulation if hits_left <= i else block_icon_healthy_modulation

func clear_icons () -> void:
	for child: Node in block_icons.get_children():
		child.queue_free()

func _ready() -> void:
	clear_icons()
	shield_component.blocked.connect(hit_taken)
	shield_component.raised.connect(create_icons)
	shield_component.lowered.connect(clear_icons)
