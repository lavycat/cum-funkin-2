extends AnimatedSprite2D
@export var base_anim:String = "idle"
var base_anim_size:Vector2:
	get:
		return sprite_frames.get_frame_texture(base_anim,0).get_size()
var anim_size:Vector2 = Vector2.ZERO
func _process(delta: float) -> void:
	anim_size = sprite_frames.get_frame_texture(animation,0).get_size()
	offset = (base_anim_size-anim_size) / 2.0
