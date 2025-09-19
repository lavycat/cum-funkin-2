class_name StoryMenuCharacter extends Node2D
@export var dance_steps:Array[String] = ["idle"]
var dance_step:int = 0
var cur_anim:String = ""
@onready var player: AnimationPlayer = $player
func _enter_tree() -> void:
	Conductor.beat_hit.connect(_beat_hit)
func _ready() -> void:
	dance()
func _beat_hit(beat:int):
	dance()
func dance():
	if dance_steps.size() > dance_step:
		play_anim(dance_steps[dance_step])
	pass
func play_anim(anim:String,force:bool = false):
	player.play(anim)
	if force:
		player.seek(0)
