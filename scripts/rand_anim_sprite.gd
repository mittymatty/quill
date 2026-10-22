extends AnimatedSprite2D

@export_subgroup("Configuration")
@export var repeat_animations: bool = false
@export var wait_min_time: float = 1.0
@export var wait_max_time: float = 5.0

@onready var anims: PackedStringArray = sprite_frames.get_animation_names()
var last_played: String

func play_anim () -> void:
	var to_play: String = anims[randi_range(0,anims.size() - 1)]
	
	if !repeat_animations and anims.size() > 1:
		while to_play == last_played: # Do not play same animation twice in a row
			to_play = anims[randi_range(0,anims.size() - 1)]
	
	last_played = to_play
	play(to_play)

func _ready() -> void:
	play_anim()
	animation_finished.connect(_on_animation_finished)

func _on_animation_finished() -> void:
	await get_tree().create_timer(randf_range(wait_min_time,wait_max_time)).timeout
	play_anim()
