# NOTE - only really used in freeplay
class_name SongMeta extends Resource
@export_subgroup("freeplay")
@export_range(1,999,1) var bpm:int = 100
@export var preview_track:AudioStream = preload("res://assets/songs/bopeebo/tracks/Inst.ogg")
@export var icon:SpriteFrames = preload("res://scenes/menus/vslice_freeplay/icons/dadpixel.res")
@export_color_no_alpha var color:Color = Color.WHITE
@export var difficulties:PackedStringArray = ["easy","normal","hard"]
@export_category("ui")
@export var hud_scene:PackedScene = preload("res://scenes/game/huds/funkin.tscn")
@export_subgroup("player")
@export var player_strum_style:StrumStyle
@export var player_note_style:NoteStyle
@export_subgroup("cpu")
@export var cpu_strum_style:StrumStyle
@export var cpu_note_style:NoteStyle
