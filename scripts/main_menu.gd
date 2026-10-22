extends Node2D
var sway_speed : float = 0.02
@onready var screen_center: Vector2 = get_viewport_rect().size / 2.0
@onready var camera_2d: Camera2D = $Camera2D
@onready var buttons_container: VBoxContainer = $Buttons

@export var input_component: InputComponent
const GAME: PackedScene = preload("uid://i6kst5rysq8k")

var selectable_buttons: Array[SwordButton]
var selected_button: int = 0

func on_button_pressed () -> void:
	var pressed_button: SwordButton = selectable_buttons[selected_button]
	if !pressed_button: return
	
	if pressed_button.name == "Quit":
		quit_game()
	elif pressed_button.name == "NewGame":
		temp_launch_game()
	elif pressed_button.name == "Settings":
		open_settings()

func on_button_hover_enter (the_button: SwordButton) -> void:
	selected_button = selectable_buttons.find(the_button)
	update_selection_swords()

func on_button_hover_leave (the_button: SwordButton) -> void:
	the_button.deselect()
	if selected_button == selectable_buttons.find(the_button):
		selected_button = -1

func on_down_pressed () -> void:
	selected_button = clampi(selected_button + 1, 0, selectable_buttons.size() - 1)
	update_selection_swords()

func on_up_pressed () -> void:
	selected_button = clampi(selected_button - 1, 0, selectable_buttons.size() - 1)
	update_selection_swords()

func update_selection_swords () -> void:
	for button: SwordButton in selectable_buttons:
		if selectable_buttons.find(button) == selected_button:
			button.select()
		elif get_tree():
			button.deselect()

func _ready() -> void:
	for child: Node in buttons_container.get_children():
		if child is SwordButton and child.visible:
			selectable_buttons.append(child)
			child.pressed.connect(on_button_pressed)
			child.mouse_entered.connect(on_button_hover_enter.bind(child))
			child.mouse_exited.connect(on_button_hover_leave.bind(child))
			child.deselect()

func _process(_delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var offset = (mouse_pos - screen_center) * sway_speed
	camera_2d.offset = offset
	
	if input_component.get_down_input():
		on_down_pressed()
	elif input_component.get_up_input():
		on_up_pressed()
	elif input_component.get_select_input() or input_component.get_jump_input():
		on_button_pressed()

func temp_launch_game () -> void:
	get_tree().call_deferred("change_scene_to_packed",GAME)

func open_settings () -> void:
	pass

func quit_game () -> void:
	get_tree().quit()
