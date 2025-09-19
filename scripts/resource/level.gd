class_name Level extends Resource
@export var name:StringName
@export var songs:Array[StringName] = []
@export_group("display")
@export var level_image:Texture
@export var level_stage:Texture2D = null
@export var dad:PackedScene = null
@export var bf:PackedScene = null
