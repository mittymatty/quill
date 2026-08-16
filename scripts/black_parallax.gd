extends Parallax2D
@onready var black_sprite: Sprite2D = $BlackSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	black_sprite.show()
