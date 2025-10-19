class_name FreeplayDj extends Node2D
var dance_beats:int = 2
var is_special_anim:bool = false
@onready var player: AnimationPlayer = $AnimationPlayer
func _ready() -> void:
	Conductor.beat_hit.connect(beat_hit)
	dance()
func dance():
	if is_special_anim:
		return
	player.play("idle")

func confirm():
	player.play("confirm")
	is_special_anim = true
	await player.animation_finished
	is_special_anim = false
	
func beat_hit(beat:int):
	if dance_beats > 0 and beat % dance_beats == 0:
		dance()
