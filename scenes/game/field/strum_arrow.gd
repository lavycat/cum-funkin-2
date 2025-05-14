class_name Receptor extends AnimatedSprite2D
@export_enum("left","down","up","right","square","left2","down2","up2","right2") var direction:String = "left"

func play_anim(anim:String = "",force:bool = false):
	if force:
		frame = 0
	play("%s %s"%[direction,anim])
