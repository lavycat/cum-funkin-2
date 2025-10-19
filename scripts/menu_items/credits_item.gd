@tool
extends Label
@export var target_y:int = 0
func _process(delta: float) -> void:
	position.y = lerp(position.y,target_y*160.0,1.0 - exp(-delta*7.5))
