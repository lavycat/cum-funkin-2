extends Node2D
var time:float = 0:
	get:
		return Time.get_ticks_msec() / 1000.0
func _process(delta: float) -> void:
	$CanvasLayer/ColorRect.material.set_shader_parameter("p",abs(sin(time)*0.9))
	pass
