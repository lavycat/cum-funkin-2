@tool
extends AnimatedSprite2D

@export var playing:bool = false:
	set(value):
		if value:
			play(animation)
		else:
			pause()
	get:
		return playing
