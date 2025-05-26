class_name FreePlaySong extends Resource
@export var name:String = "glitcher"
@export var difficulties:PackedStringArray = ["easy","normal","hard"]
@export var color:Color = Color.WHITE
@export var icon:Texture = load("res://assets/images/game/icons/icon-pico.png")
@export var icon_frames:int = 2
## only for animated icons
@export var animated_icon_frames:SpriteFrames = null
