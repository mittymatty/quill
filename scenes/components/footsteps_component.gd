class_name FootstepsComponent extends Node

@export_subgroup("Nodes")
@export var footsteps_audio: AudioStreamPlayer2D
@export var sprite: AnimatedSprite2D

@export_subgroup("Settings")
@export var frame_interval: int = 2

var last_frame_played: int

func can_play_sound (body: CharacterBody2D) -> bool:
	return sprite.animation == "run" and body.is_on_floor() and sprite.frame != last_frame_played and round(float(sprite.frame)/frame_interval) == float(sprite.frame)/frame_interval

func handle_footstep_sound (body: CharacterBody2D) -> void:
	if can_play_sound(body):
		last_frame_played = sprite.frame
		footsteps_audio.play()
