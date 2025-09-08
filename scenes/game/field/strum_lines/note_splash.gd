class_name NoteSplash extends AnimatedSprite2D
var direction:String = "left"
var style:SplashStyle = SplashStyle.new()
func play_anim(anim:String):
	frame = 0
	play("%s %s"%[anim,direction])
func _process(delta: float) -> void:
	sprite_frames = style.splash_frames
	scale = Vector2(style.splash_scale,style.splash_scale)
	visible = is_playing()
