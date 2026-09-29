class_name Enemy extends Entity

@export var team: String = "enemy"

func damage_flash(_damage_taken: float) -> void:
	var red_flash: Tween = create_tween()
	var white_flash: Tween = create_tween()
	
	white_flash.tween_property(self,"modulate:v",1,0.1).from(15)
	red_flash.tween_property(self, "modulate:s", 0, 0.1).from(15)
