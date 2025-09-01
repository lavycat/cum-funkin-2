# NOTE - only really used in freeplay
class_name SongMeta extends Resource
@export var icon:Texture = preload("uid://oqwvdi5qdt3r")
@export var icon_frames:int = 2
@export_color_no_alpha var color:Color = Color.WHITE
@export var difficulties:PackedStringArray = ["easy","normal","hard"]
@export_category("ui")
@export_subgroup("player")
@export var player_strum_style:StrumStyle
@export var player_note_style:NoteStyle
@export_subgroup("cpu")
@export var cpu_strum_style:StrumStyle
@export var cpu_note_style:NoteStyle
