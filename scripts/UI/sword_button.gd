class_name SwordButton extends Button

@onready var left_pointer_sword: Sprite2D = $LeftPointerSword
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func select () -> void:
	var show_sword: Tween = create_tween()
	show_sword.tween_property(left_pointer_sword,"modulate",Color("ffffff"),0.25)
	animation_player.play("point_at")

func deselect () -> void:
	var hide_sword: Tween = create_tween()
	hide_sword.tween_property(left_pointer_sword,"modulate",Color("ffffff00"),0.25)
	hide_sword.tween_await(get_tree().create_timer(0.25).timeout)
	hide_sword.tween_callback(animation_player.stop)
