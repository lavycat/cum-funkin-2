class_name Receptor extends AnimatedSprite2D
var direction:String = "left"
func _enter_tree() -> void:
	direction = name
func play_anim(anim:String = "",force:bool = false):
	if force:
		frame = 0
	play("%s %s"%[direction,anim])
