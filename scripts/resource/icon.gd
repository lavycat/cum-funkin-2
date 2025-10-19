class_name Icon extends Resource
## texture to be used each
## NOTE all icons are assumed to be 150x150 (or scaled down version of this) growing by the width for each frame
@export var texture:Texture2D = preload("uid://oqwvdi5qdt3r")
## number of frames horazontaly
@export var frames:int = 2:
	set(v):
		frames = max(1,frames)
## used mostly for gameplay
@export var health_map:Dictionary[float,int] = {}
