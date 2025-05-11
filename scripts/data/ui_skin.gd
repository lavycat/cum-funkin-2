class_name UISkin extends Resource
@export_category("countdown")
@export var countdown_scale:float = 1.0
@export var countdown_texs:Array[Texture] = []
@export var countdown_sounds:Array[AudioStream] = []
@export_category("player")
@export var player_strum_frames:SpriteFrames
@export var player_strum_scale:float = 0.7
@export var player_style:NoteStyle = NoteStyle.new()

@export_category("dad")
@export var dad_strum_frames:SpriteFrames
@export var dad_strum_scale:float = 0.7
@export var dad_style:NoteStyle = NoteStyle.new()
