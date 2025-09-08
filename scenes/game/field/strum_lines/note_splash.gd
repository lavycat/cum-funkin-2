class_name NoteSplash extends AnimatedSprite2D
var direction:String = "left"
func play_anim(anim:String):
	play("%s %s"%[anim,direction])
func _process(delta: float) -> void:
	visible = is_playing()
