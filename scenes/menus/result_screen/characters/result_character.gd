extends Node2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
func _ready() -> void:
	animation_player.play("intro")
	await animation_player.animation_finished
	animation_player.play("loop")
