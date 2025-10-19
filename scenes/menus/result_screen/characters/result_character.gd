extends Node2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var player:AudioStreamPlayer = AudioStreamPlayer.new()
@export var intro:AudioStream
@export var loop:AudioStream

func _ready() -> void:
	add_child(player)
	player.play()
	animation_player.play("intro")
	await animation_player.animation_finished
	animation_player.play("loop")
